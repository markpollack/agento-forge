#!/bin/bash
#
# bootstrap-research.sh — Create a research project structure using Forge methodology
#
# Usage:
#   ./bootstrap-research.sh <project-path> [--conversation <file>] [--from-dirs <dir1,dir2,...>]
#
# Examples:
#   ./bootstrap-research.sh ~/research/my-study
#   ./bootstrap-research.sh ~/research/my-study --conversation ~/chats/exploration.md
#   ./bootstrap-research.sh ~/research/my-study --from-dirs ~/old-work,~/notes
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FORGE_ROOT="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

usage() {
    echo "Usage: $0 <project-path> [--conversation <file>] [--from-dirs <dir1,dir2,...>]"
    echo ""
    echo "Arguments:"
    echo "  project-path          Path where the research project will be created"
    echo "  --conversation FILE   Optional: conversation file to copy and extract from"
    echo "  --from-dirs DIRS      Optional: comma-separated existing directories to reference"
    echo ""
    echo "Examples:"
    echo "  $0 ~/research/my-study"
    echo "  $0 ~/research/my-study --conversation ~/chats/exploration.md"
    exit 1
}

# Parse arguments
PROJECT_PATH=""
CONVERSATION=""
FROM_DIRS=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --conversation)
            CONVERSATION="$2"
            shift 2
            ;;
        --from-dirs)
            FROM_DIRS="$2"
            shift 2
            ;;
        --help|-h)
            usage
            ;;
        *)
            if [[ -z "$PROJECT_PATH" ]]; then
                PROJECT_PATH="$1"
            else
                echo -e "${RED}Error: Unknown argument: $1${NC}"
                usage
            fi
            shift
            ;;
    esac
done

if [[ -z "$PROJECT_PATH" ]]; then
    echo -e "${RED}Error: Project path is required${NC}"
    usage
fi

# Expand path
PROJECT_PATH="$(eval echo "$PROJECT_PATH")"

echo -e "${GREEN}Bootstrapping research project: ${PROJECT_PATH}${NC}"
echo ""

# Create directory structure
echo "Creating directory structure..."
mkdir -p "$PROJECT_PATH/plans/conversations"
mkdir -p "$PROJECT_PATH/plans/supporting_docs/summaries"
mkdir -p "$PROJECT_PATH/plans/learnings"
mkdir -p "$PROJECT_PATH/data/raw"
mkdir -p "$PROJECT_PATH/data/curated"
mkdir -p "$PROJECT_PATH/scripts"
mkdir -p "$PROJECT_PATH/notebooks"
mkdir -p "$PROJECT_PATH/papers"
mkdir -p "$PROJECT_PATH/findings"
mkdir -p "$PROJECT_PATH/docs"

echo -e "${GREEN}✓${NC} Directory structure created"

# Copy templates
echo "Copying templates..."

if [[ -f "$FORGE_ROOT/templates/VISION-TEMPLATE-research.md" ]]; then
    cp "$FORGE_ROOT/templates/VISION-TEMPLATE-research.md" "$PROJECT_PATH/plans/VISION.md"
    echo -e "${GREEN}✓${NC} VISION.md template copied"
else
    echo -e "${YELLOW}⚠${NC} VISION-TEMPLATE-research.md not found, creating placeholder"
    echo "# Vision: Research Project" > "$PROJECT_PATH/plans/VISION.md"
    echo "" >> "$PROJECT_PATH/plans/VISION.md"
    echo "> **Created**: $(date +%Y-%m-%d)" >> "$PROJECT_PATH/plans/VISION.md"
    echo "> **Status**: Draft" >> "$PROJECT_PATH/plans/VISION.md"
fi

if [[ -f "$FORGE_ROOT/templates/PAPER-TRACKER-TEMPLATE.md" ]]; then
    cp "$FORGE_ROOT/templates/PAPER-TRACKER-TEMPLATE.md" "$PROJECT_PATH/plans/supporting_docs/paper-tracker.md"
    echo -e "${GREEN}✓${NC} paper-tracker.md template copied"
fi

# Copy conversation if provided
if [[ -n "$CONVERSATION" ]]; then
    if [[ -f "$CONVERSATION" ]]; then
        CONV_BASENAME="$(basename "$CONVERSATION")"
        cp "$CONVERSATION" "$PROJECT_PATH/plans/conversations/$CONV_BASENAME"
        echo -e "${GREEN}✓${NC} Conversation copied to plans/conversations/$CONV_BASENAME"

        # Add reference to VISION.md
        echo "" >> "$PROJECT_PATH/plans/VISION.md"
        echo "## Key References" >> "$PROJECT_PATH/plans/VISION.md"
        echo "" >> "$PROJECT_PATH/plans/VISION.md"
        echo "- \`plans/conversations/$CONV_BASENAME\` — source conversation for this research" >> "$PROJECT_PATH/plans/VISION.md"
    else
        echo -e "${YELLOW}⚠${NC} Conversation file not found: $CONVERSATION"
    fi
fi

# Note existing directories if provided
if [[ -n "$FROM_DIRS" ]]; then
    echo "" >> "$PROJECT_PATH/plans/VISION.md"
    echo "## Existing Work References" >> "$PROJECT_PATH/plans/VISION.md"
    echo "" >> "$PROJECT_PATH/plans/VISION.md"

    IFS=',' read -ra DIRS <<< "$FROM_DIRS"
    for dir in "${DIRS[@]}"; do
        dir="$(eval echo "$dir")"
        if [[ -d "$dir" ]]; then
            echo "- \`$dir\` — existing work to incorporate" >> "$PROJECT_PATH/plans/VISION.md"
            echo -e "${GREEN}✓${NC} Referenced existing directory: $dir"
        else
            echo -e "${YELLOW}⚠${NC} Directory not found: $dir"
        fi
    done
fi

# Create a simple .gitignore
cat > "$PROJECT_PATH/.gitignore" << 'EOF'
# Data (often too large for git)
data/raw/
data/expanded/

# Python
__pycache__/
*.pyc
.ipynb_checkpoints/

# Environment
.env
*.egg-info/

# OS
.DS_Store
Thumbs.db

# Editor
*.swp
*~
EOF

echo -e "${GREEN}✓${NC} .gitignore created"

# Summary
echo ""
echo -e "${GREEN}Research project bootstrapped successfully!${NC}"
echo ""
echo "Structure created:"
echo "  $PROJECT_PATH/"
echo "  ├── plans/"
echo "  │   ├── VISION.md              ← Start here"
echo "  │   ├── conversations/"
echo "  │   ├── supporting_docs/"
echo "  │   └── learnings/"
echo "  ├── data/{raw,curated}/"
echo "  ├── scripts/"
echo "  ├── notebooks/"
echo "  ├── papers/"
echo "  ├── findings/"
echo "  └── docs/"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. cd $PROJECT_PATH"
echo "  2. Edit plans/VISION.md — fill in problem statement, research questions, hypotheses"

if [[ -n "$CONVERSATION" ]]; then
    echo "  3. Extract insights from plans/conversations/$(basename "$CONVERSATION") into VISION.md"
    echo ""
    echo -e "${YELLOW}Tip:${NC} Use Claude Code to help extract from the conversation:"
    echo "     claude \"Read plans/conversations/$(basename "$CONVERSATION") and help me extract research questions, hypotheses, and unknowns into plans/VISION.md\""
fi

echo ""
