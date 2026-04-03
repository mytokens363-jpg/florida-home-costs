#!/bin/bash
# Fix broken articles - remove thinking process and keep only frontmatter + content

cd /Users/dariusvitkus/.openclaw/workspace/rivet-business/site-template/content

# List of broken files
FILES=(
    "electrical/cost-to-install-whole-house-generator-florida-2026-2026.md"
    "hurricane-protection/cost-to-install-hurricane-impact-windows-miami-2026-2026.md"
    "hvac/cost-to-replace-hvac-system-orlando-2026-2026.md"
    "interior/cost-to-remodel-kitchen-jacksonville-2026-2026.md"
    "major-systems/cost-to-install-solar-panels-tampa-2026-2026.md"
    "pool/cost-to-install-pool-cage-naples-2026-2026.md"
)

for filepath in "${FILES[@]}"; do
    if [ -f "$filepath" ]; then
        echo "Fixing: $filepath"
        
        # Find line number of first "---" that starts frontmatter
        FIRST_DASH_LINE=$(grep -n "^---$" "$filepath" | head -1 | cut -d: -f1)
        
        if [ -n "$FIRST_DASH_LINE" ] && [ "$FIRST_DASH_LINE" -gt 1 ]; then
            echo "  Found frontmatter at line $FIRST_DASH_LINE, removing lines 1-$((FIRST_DASH_LINE-1))"
            
            # Extract frontmatter (including closing ---)
            FRONTMATTER_END=$(grep -n "^---$" "$filepath" | sed -n '2p' | cut -d: -f1)
            
            # Extract content after thinking process
            sed -n "${FIRST_DASH_LINE},${FRONTMATTER_END}p" "$filepath" > /tmp/fix_${filepath##*/}_frontmatter
            sed -n "$((FRONTMATTER_END+1)),\$p" "$filepath" > /tmp/fix_${filepath##*/}_content
            
            # Combine
            cat /tmp/fix_${filepath##*/}_frontmatter /tmp/fix_${filepath##*/}_content > "$filepath"
            
            echo "  Fixed!"
        else
            echo "  Frontmatter already at top or not found"
        fi
    fi
done

# Clean up
rm -f /tmp/fix_*
