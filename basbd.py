import requests
import json

API_KEY = "EKZy0MzzE0cDYog8KQ2FJdfrjnOfQyRYHUutuE3XUPVdln68nzfzS0eg33B0fDbu"
BASE_URL = "https://www.thebluealliance.com/api/v3"

HEADERS = {
    "X-TBA-Auth-Key": API_KEY,
    "Accept": "application/json",
}

def get_all_teams():
    """
    Fetches all FRC teams from TBA.
    Teams are paginated — each page returns up to 500 teams.
    """
    all_teams = []
    page = 0

    print("Fetching teams from The Blue Alliance API...")

    while True:
        url = f"{BASE_URL}/teams/{page}"
        response = requests.get(url, headers=HEADERS)

        if response.status_code == 200:
            teams = response.json()
            if not teams:
                # Empty page means we've fetched everything
                break
            all_teams.extend(teams)
            print(f"  Page {page}: fetched {len(teams)} teams (total so far: {len(all_teams)})")
            page += 1

        elif response.status_code == 304:
            print("No new data (304 Not Modified).")
            break

        elif response.status_code == 401:
            print("ERROR: Invalid or missing API key.")
            break

        else:
            print(f"ERROR: Received status {response.status_code} on page {page}")
            break

    return all_teams


if __name__ == "__main__":
    teams = get_all_teams()

    print(f"\nTotal teams fetched: {len(teams)}")

    # Print a summary of the first 10
    print("\nSample (first 10 teams):")
    for team in teams[:10]:
        print(f"  #{team.get('team_number')} — {team.get('nickname')} | {team.get('city')}, {team.get('state_prov')}")

    # Save all teams to a JSON file
    output_file_num = "team_numbers.txt"
    output_file_name = "team_names.txt"
    with open(output_file_num, "w") as f_num, open(output_file_name, "w") as f_name:
        for team in teams:
            f_num.write(f"{team.get('team_number')}\n")
            f_name.write(f"{team.get('nickname')}\n")
            
    print(f"\nAll teams saved to: {output_file_num} and {output_file_name}")