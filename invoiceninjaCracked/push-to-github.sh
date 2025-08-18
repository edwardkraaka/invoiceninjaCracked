#!/bin/bash

# Invoice Ninja Custom - Push to GitHub Script

echo "Invoice Ninja Custom - GitHub Push Script"
echo "========================================"
echo ""
echo "This script will help you push your customized Invoice Ninja to GitHub."
echo ""

# Check if git remote is configured
if ! git remote | grep -q "origin"; then
    echo "No remote repository configured."
    echo ""
    echo "Please follow these steps:"
    echo ""
    echo "1. Create a new PRIVATE repository on GitHub:"
    echo "   - Go to https://github.com/new"
    echo "   - Name it (e.g., 'invoiceninja-custom')"
    echo "   - Make it PRIVATE (important!)"
    echo "   - Don't initialize with README, .gitignore, or license"
    echo ""
    echo "2. After creating, run these commands:"
    echo ""
    echo "   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git"
    echo "   git push -u origin main"
    echo ""
    exit 1
fi

# Check current branch
CURRENT_BRANCH=$(git branch --show-current)
echo "Current branch: $CURRENT_BRANCH"
echo ""

# Show remote URL
REMOTE_URL=$(git remote get-url origin 2>/dev/null)
echo "Remote URL: $REMOTE_URL"
echo ""

# Check if there are uncommitted changes
if [[ -n $(git status -s) ]]; then
    echo "⚠️  You have uncommitted changes:"
    git status -s
    echo ""
    read -p "Do you want to commit them first? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "Enter commit message: " COMMIT_MSG
        git add -A
        git commit -m "$COMMIT_MSG"
    fi
fi

# Push to GitHub
echo ""
echo "Pushing to GitHub..."
git push -u origin $CURRENT_BRANCH

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Successfully pushed to GitHub!"
    echo ""
    echo "Your repository is now available at:"
    echo "$REMOTE_URL"
    echo ""
    echo "Remember:"
    echo "- Keep this repository PRIVATE"
    echo "- Don't share the URL publicly"
    echo "- Consider adding collaborators through GitHub settings if needed"
else
    echo ""
    echo "❌ Push failed. Please check your credentials and try again."
    echo ""
    echo "If you haven't set up GitHub credentials, you may need to:"
    echo "1. Create a personal access token at https://github.com/settings/tokens"
    echo "2. Use the token as your password when prompted"
fi