import os
import sys
import json
import urllib.request
import zipfile

def download_app_bundle():
    print("Fetching GitHub Actions artifacts for Krishnamishra03/rapid-system...")
    url = "https://api.github.com/repos/Krishnamishra03/rapid-system/actions/artifacts"
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    
    try:
        with urllib.request.urlopen(req) as response:
            data = json.loads(response.read().decode())
            artifacts = data.get('artifacts', [])
            
            target_artifact = None
            for art in artifacts:
                if art.get('name') == 'rapid_smart_attendance-ios-app-bundle':
                    target_artifact = art
                    break
            
            if not target_artifact:
                print("Target artifact 'rapid_smart_attendance-ios-app-bundle' not found.")
                return
            
            download_url = target_artifact.get('archive_download_url')
            artifact_id = target_artifact.get('id')
            print(f"Found artifact ID: {artifact_id}, size: {target_artifact.get('size_in_bytes')} bytes")
            print(f"Artifact page: https://github.com/Krishnamishra03/rapid-system/actions/runs/{target_artifact.get('workflow_run', {}).get('id')}")
            
    except Exception as e:
        print(f"Error fetching artifacts: {e}")

if __name__ == "__main__":
    download_app_bundle()
