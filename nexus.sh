#!/bin/bash

function rgb_line() {
    COLORS=(91 92 93 94 95 96)  # Bright Red to Bright Cyan
    C=${COLORS[$((RANDOM % ${#COLORS[@]}))]}
    echo -e "\033[1;${C}m$1\033[0m"
}

function bold_line() {
    echo -e "\033[1m$1\033[0m"
}

clear
echo ""
rgb_line "🔥 CRYPTO KOTHA × FOREST ARMY 🔥"
echo ""

read -p $'\033[1m🔑 Enter your Wallet Address: \033[0m' WALLET

echo ""
bold_line "📨 Registering user with Nexus CLI..."
nexus-network register-user --wallet-address "$WALLET"

read -p $'\033[1m📦 How many nodes do you want to run? (1-5): \033[0m' NUM_NODES

if ! [[ "$NUM_NODES" =~ ^[1-5]$ ]]; then
    echo -e "\033[1;91m❌ Invalid input. Please enter a number from 1 to 5.\033[0m"
    exit 1
fi

mkdir -p node_ids

for ((i=1; i<=NUM_NODES; i++)); do
    FILE="node_ids/node${i}.id"
    echo ""
    bold_line "🛠️ Setting up Node-$i..."

    if [ -f "$FILE" ]; then
        OLD_ID=$(cat "$FILE")
        bold_line "📂 Found existing Node ID: $OLD_ID"
        read -p $'\033[1m♻️  Use this ID? (Y/n): \033[0m' USE_OLD

        if [[ "$USE_OLD" =~ ^[Nn]$ ]]; then
            read -p $'\033[1m🆕 Enter new Node ID for Node-'$i$': \033[0m' NODE_ID
            echo "$NODE_ID" > "$FILE"
        else
            NODE_ID="$OLD_ID"
        fi
    else
        read -p $'\033[1m🆕 Enter Node ID for Node-'$i$': \033[0m' NODE_ID
        echo "$NODE_ID" > "$FILE"
    fi

    bold_line "🚀 Launching Node-$i (ID: $NODE_ID) in screen session 'no$i'..."
    screen -dmS "no$i" bash -c "nexus-network start --node-id $NODE_ID"
done

echo ""
rgb_line "✅ All nodes successfully started!"
bold_line "🖥️  To view sessions: screen -ls"
