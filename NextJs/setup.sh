#!/bin/bash

set -e

[ -f package.json ] || {
  echo "Run this script from your project root (package.json not found)"
  exit 1
}

npm install react-redux react-icons @reduxjs/toolkit antd framer-motion axios react-toastify react-markdown remark-gfm

mkdir -p .vscode src/app/auth src/app/chatBot src/app/default src/app/signup src/features src/features/auth src/features/chatBot src/features/default src/globalComponents src/globalComponents/btns src/globalService src/utils

mkdir -p src/features/auth/components src/features/auth/services src/features/auth/types src/features/auth/services/apis src/features/auth/services/data src/features/auth/services/toolkit

mkdir -p src/features/chatBot/components src/features/chatBot/services src/features/chatBot/types src/features/chatBot/services/apis src/features/chatBot/services/data src/features/chatBot/services/toolkit

mkdir -p src/features/default/components src/features/default/services src/features/default/types src/features/default/services/apis src/features/default/services/data src/features/default/services/toolkit

touch src/app/providers.tsx src/app/ClientRootLayout.tsx .env .vscode/settings.json

touch src/app/auth/page.tsx src/app/chatBot/page.tsx src/app/default/page.tsx src/app/signup/page.tsx

touch src/features/auth/components/AuthMain.tsx src/features/auth/components/SignupMain.tsx src/features/auth/services/toolkit/authSlice.ts src/features/auth/services/toolkit/authHandlers.ts src/features/auth/types/authValidators.ts src/features/auth/services/authPayload.ts

touch src/features/chatBot/components/ChatBotMain.tsx src/features/chatBot/services/toolkit/ChatBotSlice.ts src/features/chatBot/services/toolkit/ChatBotHandlers.ts src/features/chatBot/types/chatBotValidators.ts src/features/chatBot/services/chatBotPayload.ts

touch src/features/default/components/DefaultTable.tsx src/features/default/types/defaultValidators.ts

touch src/globalComponents/btns/ViewBtn.tsx src/globalComponents/Header.tsx src/globalComponents/Footer.tsx src/globalComponents/Table.tsx

touch src/globalService/Data.ts src/globalService/GlobalSlice.ts src/globalService/GlobalHandlers.ts

touch src/utils/axiosInstance.ts src/utils/formatUtils.ts src/utils/validators.ts src/utils/Store.ts

cat > .vscode/settings.json << 'EOF'
{
  "material-icon-theme.folders.associations": {
    "global_component": "global",
    "global_components": "global",
    "globalComponent": "global",
    "globalComponents": "global",
    "globalService": "robot",
    "globalServices": "robot",
    "shared_component": "components",
    "shared_components": "components",
    "sharedComponents": "components",
    "sharedComponent": "components",
    "ui_elements": "components",
    "ui_element": "components",
    "uiElements": "components",
    "uiElement": "components",
    "widgets": "components",
    "btns": "ui",
    "Bash":"robot",
    "chat":"messages",
    "Chat":"messages",
    "ChatBot":"messages",
    "chatBot":"messages",   
  }
}
EOF

cat > .env << 'EOF'
NEXT_PUBLIC_APP_BACKEND_URL="http://localhost:8000"
NEXT_PUBLIC_APP_BASE_URL="http://localhost:8000"
EOF
