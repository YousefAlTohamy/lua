
local logLocalCollissionFeature = FeatureMgr.AddFeature(Utils.Joaat("LogLocalCollision"), "Log Local Collisions", eFeatureType.Toggle, "Your log will be spammed due to local entity constantly colliding with the ground")
FeatureMgr.AddFeature(Utils.Joaat("DisableCollisionWithOtherEntites"), "Disable Entity Collision", eFeatureType.Toggle)

-- these sub tabs can be found in the bottom tab in the main click gui
ClickGUI.AddTab("Example Script", function()
	if ClickGUI.BeginCustomChildWindow("Collision Stuff") then
    	ClickGUI.RenderFeature(Utils.Joaat("LogLocalCollision"))
    	ClickGUI.RenderFeature(Utils.Joaat("DisableCollisionWithOtherEntites"))
		ClickGUI.EndCustomChildWindow()
	end
end)

-- Lets create a collision handler to manually disable some collisions

function ShouldCollideHandler(pEntityA, pEntityB, materialA, materialB, vPointA, vWorldA, vPointB, vWorldB)
    if (pEntityA == GTA.GetLocalPed() or pEntityA == GTA.GetLocalVehicle()) then
        if (logLocalCollissionFeature:IsToggled()) then
            Logger.LogInfo("Our Entity collided: " .. materialA .. " against " .. materialB)
        end

        if (pEntityB:IsPhysical() and FeatureMgr.IsFeatureToggled(Utils.Joaat("DisableCollisionWithOtherEntites"))) then
            Logger.LogInfo("Prevented Collision with entity type " .. pEntityB:GetType())
            return false -- block the collision
        end
    end

    return true -- let entites collide normally
end

-- Lets register our collision handler
EventMgr.RegisterHandler(eLuaEvent.SHOULD_COLLIDE, ShouldCollideHandler)


function CanApplyNodeData(isCreate, modelHash, position, netObject, updatedNodes)
    local modelName = GTA.GetModelNameFromHash(modelHash)
   
    local mode = isCreate and "CREATE" or "SYNC"
    Logger.LogInfo(string.format("[%s] %s (#%u) nodes=%d", mode, modelName, modelHash, #updatedNodes))
    for _, node in ipairs(updatedNodes) do
        local nodeName = node:GetNodeName()
        Logger.LogInfo(" - " .. nodeName)
    end

    for _, node in ipairs(updatedNodes) do
        if node:GetNodeType() == eSyncDataNode.CPedGameStateDataNode then
            local pPedGameStateDataNode = node:As("CPedGameStateDataNode")
            if pPedGameStateDataNode and pPedGameStateDataNode.onMount then
                Logger.LogInfo("Blocked Invalid Mount from " .. netObject.PlayerId)
                return false
            end
        end
    end

    return true
end

EventMgr.RegisterHandler(eLuaEvent.CAN_APPLY_NODE_DATA, CanApplyNodeData)


local SCRIPT_EVENT_COLLECTIBLE_COLLECTED = 968269233 -- note: script event hashes often change after game updates

-- Every Script Event has this base structure
function ConstructBasScriptEvent(scriptEventHash)
    local baseArgs = {}
    baseArgs[1] = scriptEventHash -- first arg for every script event is the event hash
    baseArgs[2] = GTA.GetLocalPlayerId()
    baseArgs[3] = -1 -- dont mind the 3rd arg since it will be set to the receiverBs by the API

    return baseArgs
end

-- AddPlayerFeature simple adds 32 features 
-- Only difference is that these are automatically reset when Cherax adds/removes a player from the player list
-- Instead of a direct feature instances the corresponding 32 feature hashes are returned
FeatureMgr.AddPlayerFeature(Utils.Joaat("RemoteGiveCollectible"), "Give Collectible", eFeatureType.Button, "Player Button Description", function(f)
    local featureName = f:GetName()
    local playerId = f:GetPlayerIndex() -- in player feature callbacks always use f:GetPlayerIndex() instead of Utils.GetSelectedPlayer !!

    local args = ConstructBasScriptEvent(SCRIPT_EVENT_COLLECTIBLE_COLLECTED)
    args[4] = 0 -- eCollectible -- Movie Props
    args[5] = 0 -- iWhichCollectible
    args[6] = 1 -- bCollected
    args[7] = 1 -- bDelivered
    args[8] = 1 -- bPrintMessage

    local receiverBitset = 1 << playerId -- we only want it to send it to this player, so set a bit at his player index
    GTA.TriggerScriptEvent(receiverBitset, args) -- send the script event

    Logger.LogInfo(featureName .. " successfully executed")
end)

FeatureMgr.AddPlayerFeature(Utils.Joaat("OpenRockstarProfile"), "Open Rockstar Profile", eFeatureType.Button, "Description", function(f)
    local pPlayer = Players.GetById( f:GetPlayerIndex())
    if pPlayer ~= nil then
        local rid = pPlayer:GetGamerInfo().RockstarId
        local gh = GamerHandle.New(rid)
        local scrGh = gh:ToBuffer()
        --NETWORK.NETWORK_SHOW_PROFILE_UI(scrGh:GetBuffer())
    end
end)

-- Function: ScriptedGameEventHandler(pPlayer, args)
-- Description: Handle received script events and decide to block block them
-- Parameters:
--    pPlayer (CNetGamePlayer): The sender of that script event.
--    args (table): The script event data.
-- Return Values:
--    result (bool): Return true to block.
function ScriptedGameEventHandler(pPlayer, args)

    -- Logger.LogInfo("Received Script Event Has: " .. args[1])
    if args[1] == SCRIPT_EVENT_COLLECTIBLE_COLLECTED then
        Logger.LogInfo("Received SCRIPT_EVENT_COLLECTIBLE_COLLECTED from " .. pPlayer:GetName())
        return true -- return true to block, for example we dont want it
    end
    
    return false
end

-- Lets register our script event handler so we can see what was returned by the SCRIPT_EVENT_CHARACTER_STAT_DATA_QUERY_INT request
EventMgr.RegisterHandler(eLuaEvent.SCRIPTED_GAME_EVENT, ScriptedGameEventHandler)

function MakeLoopedOnTickPlayerFeature(hash, name, fType, desc, callback, executeInNativeThread)
	local hashes = FeatureMgr.AddPlayerFeature(hash, name, fType, desc, callback, executeInNativeThread) -- AddPlayerFeature returns all 32 feature hashes
	for _, hash in pairs(hashes) do -- for each feature hash
        local feature = FeatureMgr.GetFeature(hash) -- lets grab the feature by its hash
		feature:RegisterCallbackTrigger(eCallbackTrigger.OnTick) -- register
	end
end

MakeLoopedOnTickPlayerFeature(Utils.Joaat("PlayerLoop1"), "Player Loop 1", eFeatureType.Toggle, "Player Loop 1 Description", function(f)
	if (f:IsToggled()) then
        local featureName = f:GetName()
		local playerId = f:GetPlayerIndex()
		Logger.LogInfo(featureName .. " is toggled for player with id " .. playerId)
	end
end, true)


ClickGUI.AddPlayerTab("Cherax Example", function()
	if ClickGUI.BeginCustomChildWindow("Example Child Window") then
		ClickGUI.RenderFeature(Utils.Joaat("PlayerLoop1"), Utils.GetSelectedPlayer()) -- since its a player feature we need the player index we want to render if for, the feature could be toggled for one player but for others not
		ClickGUI.EndCustomChildWindow()
	end
    if ClickGUI.BeginCustomChildWindow("Another Child Window") then
		ClickGUI.RenderFeature(Utils.Joaat("RemoteGiveCollectible"), Utils.GetSelectedPlayer()) -- since its a player feature we need the player index we want to render if for
		ClickGUI.EndCustomChildWindow()
	end
end)
    