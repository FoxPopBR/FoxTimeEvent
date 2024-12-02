
# FoxTimeEvent Mod

## Overview

**FoxTimeEvent** is a mod for **Project Zomboid** designed to manage scheduled events efficiently and accurately. Aimed at content creators and mod developers, FoxTimeEvent offers a centralized solution for time checks and custom triggers based on specific in-game dates or time intervals. This mod not only optimizes the game's resource usage but also facilitates integration with multiple mods, providing a smoother and more efficient gaming experience.

---

## Key Features

- **Centralized Management of Temporal Events:**  
  FoxTimeEvent acts as the only required time-check system, eliminating the need for multiple time-check systems across different mods.

- **Custom Time-Based Triggers:**  
  Allows the creation and management of custom event triggers that are activated at specific in-game dates or after a defined time interval.

- **Resource Efficiency:**  
  By centralizing time checks and triggers in a single system, it significantly reduces resource usage, making the game more efficient.

- **Organized Data Persistence:**  
  Stores all event information in a structured text file, ensuring data persistence across game sessions.

---

## Benefits of Using FoxTimeEvent

### 1. **Resource Efficiency**

- **Centralized Checks:**  
  By using FoxTimeEvent as the sole time-check system, it avoids the overhead caused by multiple time-check systems running simultaneously.

- **Dynamic Scheduling:**  
  The system adjusts the frequency of checks (daily, hourly, every ten minutes, or every minute) based on the proximity of the next event, ensuring resources are optimally utilized.

### 2. **Accuracy and Precision**

- **Precise Time Comparison System:**  
  Uses a detailed comparison of time units (year, month, day, hour, minute) to ensure the highest accuracy when triggering events.

- **Blend of Efficiency and Precision:**  
  Combines efficient checks with high precision, ensuring that events are triggered at the exact moment without wasting resources.

### 3. **Ease of Use and Integration**

- **Intuitive API:**  
  Provides clear and well-defined functions for registering and managing events, making integration with other mods straightforward.

- **Flexibility for Multiple Requests:**  
  Capable of processing multiple simultaneous requests through a queue system, ensuring all events are managed in an orderly and efficient manner.

### 4. **Compatibility and Scalability**

- **Adoptable as a Standard:**  
  When used as a base for time verification, it allows multiple mods to benefit from a unified system, reducing redundancy and improving compatibility.

- **Simplified Maintenance:**  
  With a single system managing events, maintenance and updates become simpler and less prone to conflicts.

---

## Verification Process

FoxTimeEvent uses a dynamic verification system that adjusts the frequency of checks based on the proximity of the next event to be triggered. This process combines efficiency and precision, optimizing resource usage.

### Verification Frequency

- **More than 26 hours remaining:** Daily checks.
- **Between ~11 minutes and 26 hours:** Hourly checks.
- **Between ~1 minute and ~11 minutes:** Checks every ten minutes.
- **Less than ~1 minute:** Checks every minute.

### Benefits

- **Efficiency:** Reduces the number of checks needed when no events are imminent, saving system resources.
- **Precision:** Increases the frequency of checks as the event approaches, ensuring the trigger is executed at the exact moment.

---

## Data Persistence

All registered events are stored in a well-organized text file, ensuring persistence across game sessions.

### Event File Format

Each line in the event file represents a registered event and contains detailed information about the event. The format is structured and easy to understand, facilitating integration with other mods.

**Example of Event File Entry:**

```
|id000000017_MyTestMod|2024/12/01 ((UTC)19:50:43)|NicolasLombardo|1993,6,11,9,0|1993,7,12,12,0|MyTestMod|MyTestMod_onEventTriggered|Specific date event has been triggered!|
|id000000015_MyTestMod|2024/12/01 ((UTC)19:50:43)|CharlesChild|1993,6,11,21,24|1993,7,12,12,0|MyTestMod|MyTestMod_onEventTriggered|Specific date event has been triggered!|
```

---

## Current Version Limitations

- **Time-Based Triggers Only:**  
  The current version of FoxTimeEvent supports creating events triggered by specific in-game dates or added time intervals only. It does not support other types of triggers, such as weather changes, seasons, or events based on specific game conditions.

---

## Future Expansions

- **Triggers Based on In-Game Events:**  
  Implement triggers that respond to weather changes, seasons, or other dynamic in-game events.
  
- **Integration with Other Event Systems:**  
  Allow FoxTimeEvent to interact with existing event systems in other mods, promoting greater flexibility and functionality.
  
- **Community Feedback:**  
  Base future functionalities and expansions on requests and needs from the modding community.

---

## Contribute to the Project

FoxTimeEvent was created to address problems faced when developing other mods and to assist the **Project Zomboid** modding community. The mod is open-source and available for collaboration and improvement.

### GitHub Repository

You can access the FoxTimeEvent repository, contribute with enhancements, report bugs, or suggest new features through the following link:

🔗 **[FoxTimeEvent on GitHub](https://github.com/FoxPopBR/FoxTimeEvent)**
