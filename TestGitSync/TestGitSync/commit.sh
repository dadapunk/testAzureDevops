#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e
# Set required environment variables
AZUREPAT=${AZUREPAT:?Need to set AZUREPAT}
AZUSERNAME=${AZUSERNAME:?Need to set AZUSERNAME}
AZUSER_EMAIL=${AZUSER_EMAIL:?Need to set AZUSER_EMAIL}
AZORG=${AZORG:?Need to set AZORG}
# Set repository and folder names
GITHUB_REPO="https://github.com/dadapunk/testAzureDevops.git"
GITHUB_FOLDER="testAzureDevops"
AZURE_FOLDER="TestGitSync"
AZURE_REPO="https://$AZUSERNAME:$AZUREPAT@dev.azure.com/$AZORG/$AZURE_FOLDER/_git/$AZURE_FOLDER"
# Clone the GitHub repository
git clone $GITHUB_REPO
# Navigate to the cloned repository and remove the .git directory
cd $GITHUB_FOLDER
rm -rf .git
# Navigate back to the parent directory
cd ..
# Clone the Azure DevOps repository
git clone $AZURE_REPO
# Use rsync to copy files from the GitHub repository to the Azure DevOps repository
rsync -av --delete $GITHUB_FOLDER/ $AZURE_FOLDER/
# Navigate to the Azure DevOps repository
cd $AZURE_FOLDER
# Configure git user details locally
git config user.email "$AZUSER_EMAIL"
git config user.name "$AZUSERNAME"
# Add, commit, and push changes
git add .
git commit -m "sync from git to azure"
git push