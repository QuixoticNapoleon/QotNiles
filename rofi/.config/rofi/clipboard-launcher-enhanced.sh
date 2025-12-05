#!/usr/bin/env bash
#==============================================================================
# Enhanced Greenclip Clipboard Manager with Image Support
#==============================================================================
# This script provides a fully-functional clipboard manager using rofi and
# greenclip, with proper support for both text and images.
#
# Features:
#   - Displays clipboard history from greenclip
#   - Shows image thumbnails for copied images
#   - Truncates long text for readability
#   - Properly pastes both text AND images back to clipboard
#   - Handles greenclip's image format: "image/png Zen [hash]"
#
# Requirements:
#   - rofi (with script mode and thumbnail support)
#   - greenclip (clipboard manager daemon must be running)
#   - xsel (for clipboard operations - prevents rofi freeze issues)
#   - Image files stored in /tmp/greenclip/ (configured in greenclip.toml)
#
# How Greenclip Stores Images:
#   1. Text entries: Stored as-is in clipboard history
#   2. Image entries: Stored as "image/png Zen [hash]" in history
#   3. Actual PNG files: Saved to /tmp/greenclip/[hash].png
#   4. This script: Detects images, shows thumbnails, and restores them properly
#==============================================================================

# Directory where greenclip caches image files
# IMPORTANT: This must match image_cache_directory in ~/.config/greenclip.toml
IMGDIR="/tmp/greenclip"

# Maximum text length to display before truncating
MAX_TEXT_LENGTH=100

#------------------------------------------------------------------------------
# clipboard_mode() - Main rofi script mode handler
#------------------------------------------------------------------------------
# Called by rofi in two contexts:
#
# Context 1: ROFI_RETV=0 (Initial call)
#   - Generate the menu items from greenclip history
#   - Detect image vs text entries
#   - Format with thumbnails and truncation
#   - Store original content in info field for later retrieval
#
# Context 2: ROFI_RETV=1 (User selected item)
#   - Receive selection via $ROFI_INFO
#   - Determine if it's an image or text
#   - Copy to clipboard appropriately (file for images, text for text)
#------------------------------------------------------------------------------
clipboard_mode() {
    if [ "$ROFI_RETV" = "0" ]; then
        #----------------------------------------------------------------------
        # CONTEXT 1: Generate Menu Items
        #----------------------------------------------------------------------

        # Read clipboard history line by line from greenclip
        greenclip print | while IFS= read -r line; do

            #------------------------------------------------------------------
            # IMAGE DETECTION AND DISPLAY
            #------------------------------------------------------------------
            # Greenclip outputs image entries in format: "image/png Zen [hash]"
            # We need to:
            #   1. Detect these entries (starts with "image/")
            #   2. Extract the hash/ID
            #   3. Find the corresponding PNG file in IMGDIR
            #   4. Display with thumbnail icon
            #------------------------------------------------------------------

            if [[ "$line" =~ ^image/png ]]; then
                # This is an image entry!

                # Extract the hash from "image/png Zen [hash]"
                # The hash is the last field (may be negative number)
                hash=$(echo "$line" | awk '{print $NF}')

                # Construct the image file path
                # Note: greenclip saves as [hash].png or [-hash].png
                imgfile="$IMGDIR/${hash}.png"

                # Check if image file exists
                if [ -f "$imgfile" ]; then
                    # Get just the filename for display
                    imgname=$(basename "$imgfile")

                    # Display format for rofi:
                    # [display text] \0 icon \x1f [thumbnail path] \0 info \x1f [original line]
                    #
                    # Components:
                    # - Display: "🖼️  Image: filename.png" (what user sees)
                    # - Icon: thumbnail://path (shows image preview)
                    # - Info: original greenclip line (used for restoration)
					# printf '🖼️  Image: %s\0icon\x1fthumbnail://%s\0info\x1f%s\n' \
                    printf '󰋩 IMAGE: %s\0icon\x1fthumbnail://%s\0info\x1f%s\n' \
                           "$imgname" \
                           "$imgfile" \
                           "$line"
                else
                    # Image file not found, show as broken/missing
                    # Still preserve the original line in case file appears later
					# printf '🖼️  Image (missing): %s\0info\x1f%s\n' \
					printf '󰠫  IMAGE (MISSING): %s\0info\x1f%s\n' \
                           "$hash" \
                           "$line"
                fi

                # Done processing this image entry, move to next line
                continue
            fi

            #------------------------------------------------------------------
            # TEXT ENTRY DISPLAY
            #------------------------------------------------------------------
            # For regular text clipboard entries:
            #   1. Truncate if too long (for display)
            #   2. Preserve full original text in info field (for pasting)
            #------------------------------------------------------------------

            if [ ${#line} -gt $MAX_TEXT_LENGTH ]; then
                # Text is long - truncate for display but preserve original
                display_text="${line:0:$MAX_TEXT_LENGTH}..."

                # Format: [truncated text] \0 info \x1f [full original text]
                # User sees truncated version, but pastes full version
                printf '%s\0info\x1f%s\n' "$display_text" "$line"
            else
                # Text is short - can display as-is
                # Still use info field for consistency in selection handling
                printf '%s\0info\x1f%s\n' "$line" "$line"
            fi
        done

    else
        #----------------------------------------------------------------------
        # CONTEXT 2: Handle User Selection
        #----------------------------------------------------------------------
        # User selected an item. $ROFI_INFO contains the original content
        # we stored in the info field during menu generation.
        #
        # We need to:
        #   1. Check if selection is an image or text
        #   2. For images: Copy the PNG file to clipboard
        #   3. For text: Copy the text to clipboard
        #----------------------------------------------------------------------

        selection="$ROFI_INFO"

        #----------------------------------------------------------------------
        # IMAGE SELECTION HANDLING
        #----------------------------------------------------------------------
        # Check if selected item is an image entry (starts with "image/png")
        #----------------------------------------------------------------------
        if [[ "$selection" =~ ^image/png ]]; then
            # This is an image! Extract hash and copy the actual PNG file

            # Parse hash from "image/png Zen [hash]"
            hash=$(echo "$selection" | awk '{print $NF}')

            # Construct image file path
            imgfile="$IMGDIR/${hash}.png"

            # Verify image file exists before copying
            if [ -f "$imgfile" ]; then
                # Copy the actual PNG file to clipboard as image data
                # Using xsel instead of xclip to prevent rofi freeze issues
                # -b: Use clipboard (equivalent to --clipboard)
                # -i: Read from stdin/file
                xsel --clipboard --input < "$imgfile"

                # Exit successfully - image is now in clipboard
                exit 0
            else
                # Image file not found - show error notification if dunstify available
                if command -v dunstify &> /dev/null; then
                    dunstify -u critical "Clipboard Error" "Image file not found: $imgfile"
                fi
                # Exit with error code
                exit 1
            fi
        else
            #------------------------------------------------------------------
            # TEXT SELECTION HANDLING
            #------------------------------------------------------------------
            # This is regular text - copy to clipboard as text
            #------------------------------------------------------------------

            # Copy text directly to clipboard using xsel
            # Using xsel instead of xclip to prevent rofi freeze issues
            # -b: Use clipboard (equivalent to --clipboard)
            # -i: Read from stdin
            # Using echo -n to avoid adding newline
            echo -n "$selection" | xsel --clipboard --input

            # Exit successfully - text is now in clipboard
            exit 0
        fi
    fi
}

#==============================================================================
# Export for rofi script mode
#==============================================================================
# Make function and variables available when rofi spawns this script
export -f clipboard_mode
export IMGDIR
export MAX_TEXT_LENGTH

#==============================================================================
# MAIN SCRIPT ENTRY POINT
#==============================================================================
# Two execution modes based on ROFI_RETV environment variable:
#
# MODE 1: Direct execution (ROFI_RETV is unset/empty)
#   - User ran this script from command line or keybind
#   - Launch rofi with this script as the clipboard provider
#   - Rofi will then call this script again in MODE 2
#
# MODE 2: Called by rofi (ROFI_RETV is set)
#   - Rofi is calling us to get menu items or handle selection
#   - Call clipboard_mode() function to handle the request
#==============================================================================

if [ -z "$ROFI_RETV" ]; then
    #--------------------------------------------------------------------------
    # MODE 1: Launch rofi
    #--------------------------------------------------------------------------

    # Launch rofi with this script as the data source for "clipboard" mode
    #
    # Rofi parameters:
    # -modi "clipboard:$0"
    #   Register "clipboard" mode that runs this script for data
    #
    # -show clipboard
    #   Display the clipboard mode immediately
    #
    # NO -run-command needed!
    #   The script handles clipboard copying internally for both text and images
    #   When user selects an item, rofi calls the script with ROFI_RETV=1
    #   The script then copies to clipboard directly and exits
    #
    # -theme ...
    #   Custom theme file for visual styling
    #--------------------------------------------------------------------------

    rofi -modi "clipboard:$0" \
         -show clipboard \
         -theme ~/.config/rofi/clipboard.rasi

    # NOTE: All clipboard operations are handled inside clipboard_mode()
    # when ROFI_RETV=1 (selection mode). No post-processing needed here.

else
    #--------------------------------------------------------------------------
    # MODE 2: Provide data to rofi or handle selection
    #--------------------------------------------------------------------------

    # Rofi is calling us - hand off to clipboard_mode function
    clipboard_mode "$@"
fi

#==============================================================================
# OLD/ALTERNATIVE APPROACHES (Commented out for reference)
#==============================================================================
#
# APPROACH 1: Using -run-command with xclip for text
# This was the old approach that didn't handle images properly:
#
# rofi -modi "clipboard:$0" \
#      -show clipboard \
#      -run-command 'echo -n {cmd} | xclip -selection clipboard' \
#      -theme ~/.config/rofi/clipboard.rasi
#
# PROBLEM: This pipes ALL selections (including "image/png Zen [hash]" text)
# to xclip as text, which doesn't restore the actual image to clipboard.
#
# SOLUTION: Handle image copying inside the script, before rofi's -run-command,
# by detecting image format and using xclip with -t image/png and the file.
#
#==============================================================================
