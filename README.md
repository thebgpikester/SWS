### License
 This file is part of Simple Warehouse Saving.
 Copyright (C) 2023 Michael Cole

 Simple Warehouse Saving is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
# README 
Simple Warehouse Saving by Pikey Aug 2023 version 1.0 (thebgpikester@hotmail.com)

Thanks to Speed and Grimes for IntegratedbasicSerialize() function 

Thanks to Eagle Dynamics for keeping the dream alive.

This software is licensed under the Lesser GNU GPL 2007 
Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>

https://www.gnu.org/licenses/lgpl-3.0.txt
This script is supplied with the full LICENSE at https://github.com/thebgpikester/SWS

## PREREQS
Requires lfs and io desanitized from missionscripting.lua.
No 3rd party SSE like Mist or Moose required.

## WHAT IT DOES
Gets the contents of all DCS Airbase warehouses in the mission and saves them to file. Reloads from the save every mission. (no prompts)

## USAGE
Load this script at mission start as a DO SCRIPT.
By default, DCS sets unlimited warehouses. Set some warehouses to have limited contents by clicking on them in the Mission Editor and unchecking 'Unlimited' next to any of aircraft, fuel and weapons. Set a fixed limit amount. Optionally, setup supply chains as per pg 104 DCS user manual EN 2020.pdf in your main DCS installation\Doc folder.

## CONFIGURABLE ITEMS
SWS.filepath = lfs.writedir().."SimpleWarehouse.lua"
You can configure a custom directory for the save file here if needs be.

SWS.updateDelaySeconds = 60
You can change the timer interval for the saving of warehouses here. 
SWS.filepath = lfs.writedir().."SimpleWarehouse.lua"
You can configure a custom directory for the save file here if needs be.
