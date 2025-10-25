#!/bin/bash

# HeyBuddyDesign - Quick Push to GitHub
# This script helps you push your code to GitHub

echo "🚀 HeyBuddyDesign - GitHub Push Script"
echo "======================================"
echo ""

# Navigate to project directory
cd "$(dirname "$0")"

# Check git status
echo "📊 Checking git status..."
git status
echo ""

# Ask for commit message
read -p "📝 Enter commit message (or press Enter for default): " commit_msg

# Use default message if empty
if [ -z "$commit_msg" ]; then
    commit_msg="Update HeyBuddyDesign website"
fi

# Add all files
echo "📦 Adding files..."
git add -A

# Check if there are changes
if git diff --staged --quiet; then
    echo "ℹ️  No changes to commit"
    echo ""
    read -p "🚀 Push anyway? (y/n): " push_anyway
    if [ "$push_anyway" != "y" ]; then
        echo "Cancelled."
        exit 0
    fi
else
    # Commit changes
    echo "💾 Committing changes..."
    git commit -m "$commit_msg"
fi

# Push to GitHub
echo ""
echo "🚀 Pushing to GitHub..."
echo "Repository: https://github.com/guerro47/HeyBuddyDesign.git"
echo ""

git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Successfully pushed to GitHub!"
    echo ""
    echo "📊 Next steps:"
    echo "  1. Visit: https://github.com/guerro47/HeyBuddyDesign"
    echo "  2. Deploy on Vercel: https://vercel.com/new"
    echo "  3. Select 'guerro47/HeyBuddyDesign' repository"
    echo "  4. Click 'Deploy'"
    echo ""
    echo "🎉 Your changes are live on GitHub! Welcome to the cloud, buddy! 💚"
else
    echo ""
    echo "❌ Push failed!"
    echo ""
    echo "💡 Common solutions:"
    echo "  • Make sure you have GitHub access"
    echo "  • Use a Personal Access Token (see GITHUB_VERCEL_DEPLOYMENT.md)"
    echo "  • Check your internet connection"
    echo "  • Try: git pull origin main"
    echo ""
fi
