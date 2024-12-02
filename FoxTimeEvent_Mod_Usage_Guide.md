
# How to Use the FoxTimeEvent Mod in Your Own Mod

The **FoxTimeEvent Mod** provides a centralized and efficient system for scheduling and managing time-based triggers in **Project Zomboid**. Below are detailed explanations and examples of how other mods can utilize the features of this mod.

---

## Basic Concepts

### 1. Registering Events
FoxTimeEvent allows you to register events that will trigger callbacks:
- **At a specific in-game date.**
- **After a specified time interval (relative to the current in-game time).**

These events are registered and saved persistently, ensuring they are not lost across game sessions.

### 2. Callback Functions
A **callback function** is a Lua function that will be executed when the event is triggered. It is a way for your mod to perform specific actions when the scheduled event time arrives.

---

## Example 1: Register an Event After a Time Interval

You can register an event to trigger a callback after a certain amount of in-game time has passed.

### Code Example:
```lua
local addTimeTable = {0, 0, 1, 2, 30}  -- 0 years, 0 months, 1 day, 2 hours, 30 minutes
local playerID = "Player123"
local modName = "MyCustomMod"
local callbackName = "onEventTriggered"
local customMessage = "Your custom event has been triggered!"

FoxTimeEvent.registerEventWithInterval(addTimeTable, playerID, modName, callbackName, customMessage)
```

### Explanation:
- **`addTimeTable`**: Specifies the time interval after which the event should trigger.
- **`playerID`**: The ID of the player associated with the event.
- **`modName`**: The name of your mod registering the event.
- **`callbackName`**: The name of the callback function that will execute when the event is triggered.
- **`customMessage`**: A personalized message you can use inside your callback function.

### Callback Function:
```lua
function onEventTriggered(event)
    print("Event triggered for player: " .. event.idPlayer)
    print("Custom Message: " .. event.customMessage)
    -- Additional logic for the event
end
```

---

## Example 2: Register an Event for a Specific Date

If you want an event to trigger at an exact in-game date and time, you can use `registerEventAtDate`.

### Code Example:
```lua
local targetDate = {2024, 12, 25, 18, 0}  -- Year, Month, Day, Hour, Minute
local playerID = "Player456"
local modName = "HolidayMod"
local callbackName = "onChristmasEvent"
local customMessage = "Merry Christmas! Your event is triggered!"

FoxTimeEvent.registerEventAtDate(targetDate, playerID, modName, callbackName, customMessage)
```

### Explanation:
- **`targetDate`**: Specifies the exact in-game date and time when the event will trigger.
- **Other parameters**: Same as in Example 1.

### Callback Function:
```lua
function onChristmasEvent(event)
    print("Event triggered for player: " .. event.idPlayer)
    print("Custom Message: " .. event.customMessage)
    -- Add logic for Christmas rewards or actions
end
```

---

## Example 3: Grant a Player an Item After a Delay

Suppose you want to grant a player a special item 2 in-game days after an action.

### Code Example:
```lua
local addTimeTable = {0, 0, 2, 0, 0}  -- 0 years, 0 months, 2 days, 0 hours, 0 minutes
local playerID = "Player789"
local modName = "RewardMod"
local callbackName = "giveSpecialItem"
local customMessage = "You received a special item as a reward!"

FoxTimeEvent.registerEventWithInterval(addTimeTable, playerID, modName, callbackName, customMessage)
```

### Callback Function:
```lua
function giveSpecialItem(event)
    local player = getPlayerByID(event.idPlayer)
    if player then
        player:getInventory():AddItem("Base.SpecialItem")
        print(event.customMessage)
    end
end
```

---

## Example 4: Create a Repeating Event

FoxTimeEvent doesn’t natively support recurring events, but you can create one by re-registering the event inside the callback.

### Code Example:
```lua
function repeatingEvent(event)
    print("Repeating event triggered for player: " .. event.idPlayer)

    -- Logic for the event
    local addTimeTable = {0, 0, 0, 12, 0}  -- Trigger every 12 in-game hours
    FoxTimeEvent.registerEventWithInterval(addTimeTable, event.idPlayer, event.modName, "repeatingEvent", "The event will repeat in 12 hours!")
end
```

### Explanation:
- Inside the callback function, a new event is registered with the same callback, creating a loop of recurring events.

---

## Features of FoxTimeEvent for Other Mods

1. **Persistence Across Sessions:**
   Events are saved persistently, so they will continue to exist even if the game is restarted.

2. **Multiple Events for Multiple Mods:**
   FoxTimeEvent can handle multiple events from multiple mods simultaneously, using its queue system to manage triggers in order.

3. **Custom Messages:**
   You can include custom messages that provide context or feedback when the callback is triggered.

4. **Flexibility:**
   Use FoxTimeEvent for time-based rewards, NPC actions, environmental changes, or any other event you can imagine.

---

## How to Add Your Mod’s Custom Logic

### Step 1: Define a Callback
Create a global function in your mod with the logic you want to execute when the event is triggered.

**Example:**
```lua
function myCustomCallback(event)
    print("Custom event logic for player: " .. event.idPlayer)
end
```

### Step 2: Register the Event
Call `registerEventWithInterval` or `registerEventAtDate` with the necessary parameters to tie your callback to a specific event.

---

## Example Use Cases for Other Mods

1. **Quest Mod:**  
   Trigger quest progression after a set amount of in-game time.

2. **Seasonal Events Mod:**  
   Schedule in-game events to happen on specific dates.

3. **Skill Training Mod:**  
   Provide skill points or bonuses after a training session ends.

4. **Weather Control Mod:**  
   Activate weather changes at predefined times.

5. **Story Progression Mod:**  
   Drive the story forward by triggering cutscenes or dialogues after certain delays.

---

## Conclusion

The **FoxTimeEvent Mod** is a powerful tool for managing time-based triggers in your mods. By centralizing time checks and callbacks, it ensures efficient resource usage while providing a flexible API for a wide variety of use cases.

For more details, check the GitHub repository:
🔗 **[FoxTimeEvent on GitHub](https://github.com/FoxPopBR/FoxTimeEvent)**
