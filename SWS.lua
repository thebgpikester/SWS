--Simple Warehouse Saving by Pikey Aug 2023 version 1.0
--Thanks to SPeed and Grimes for IntegratedbasicSerialize() function 

--This software is licensed under the Lesser GNU GPL 2007 
-- Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
-- Everyone is permitted to copy and distribute verbatim copies
-- of this license document, but changing it is not allowed.
--https://www.gnu.org/licenses/lgpl-3.0.txt
--
--PREREQS
--Requires lfs and io desanitized from missionscripting.lua.
--No 3rd party SSE like Mist or Moose required.

--WHAT IT DOES
--Gets the contents of all Airbase warehouses in the mission and saves them to file. Reloads from the save every mission. (no prompts)
--USAGE
--Load this script at mission start.
--By default, DCS sets unlimited warehouses. Set some warehouses to have limited contents by clicking on them in the Mission Editor and 
--unchecking 'Unlimited' next to any of aircraft, fuel and weapons. Set a fixed limit amount. Optionally, setup supply chains as 
--per pg 104 DCS user manual EN 2020 pdf. in your main installation\Doc folder.

SWS={} --don't touch
SWS.filepath = lfs.writedir().."SimpleWarehouse.lua" --the file location is the root of your DCS instance Saved Games\DCS\ folder
SWS.updateDelaySeconds = 60 --edit this, in testing there was no discernible impact.

--COMMON FUNCTIONS
 function SWS.IntegratedbasicSerialize(s)
    if s == nil then
      return "\"\""
    else
      if ((type(s) == 'number') or (type(s) == 'boolean') or (type(s) == 'function') or (type(s) == 'table') or (type(s) == 'userdata') ) then
        return tostring(s)
      elseif type(s) == 'string' then
        return string.format('%q', s)
      end
    end
  end
  
-- imported slmod.serializeWithCycles (thanks to Speed and Grimes)
  function SWS.IntegratedserializeWithCycles(name, value, saved)
    local basicSerialize = function (o)
      if type(o) == "number" then
        return tostring(o)
      elseif type(o) == "boolean" then
        return tostring(o)
      else -- assume it is a string
        return SWS.IntegratedbasicSerialize(o)
      end
    end

    local t_str = {}
    saved = saved or {}       -- initial value
    if ((type(value) == 'string') or (type(value) == 'number') or (type(value) == 'table') or (type(value) == 'boolean')) then
      table.insert(t_str, name .. " = ")
      if type(value) == "number" or type(value) == "string" or type(value) == "boolean" then
        table.insert(t_str, basicSerialize(value) ..  "\n")
      else

        if saved[value] then    -- value already saved?
          table.insert(t_str, saved[value] .. "\n")
        else
          saved[value] = name   -- save name for next time
          table.insert(t_str, "{}\n")
          for k,v in pairs(value) do      -- save its fields
            local fieldname = string.format("%s[%s]", name, basicSerialize(k))
            table.insert(t_str, SWS.IntegratedserializeWithCycles(fieldname, v, saved))
          end
        end
      end
      return table.concat(t_str)
    else
      return ""
    end
  end

function SWS.file_exists(name) 
    if lfs.attributes(name) then
    return true
    else
    return false end 
end

function SWS.writemission(data, file)
  SWS.File = io.open(file, "w")
  SWS.File:write(data)
  SWS.File:close()
end

local Airbases = world.getAirbases()

SWS.airbaseContents = {}

function saveWarehouseContents() 
  
 for i=1, #(Airbases) do
    local w=Airbases[i]:getWarehouse()
    local Inv = w:getInventory()
    SWS.airbaseContents[Airbases[i]:getName()]=Inv
 end

return timer.getTime() + SWS.updateDelaySeconds
end

function serializeWarehouseContents()
   SWS.newMissionStr = SWS.IntegratedserializeWithCycles("SWS.SimpleWarehouse",SWS.airbaseContents)
   return timer.getTime() + SWS.updateDelaySeconds
end

function writeWarehouseContents()
  SWS.writemission(SWS.newMissionStr, SWS.filepath)
  return timer.getTime() + SWS.updateDelaySeconds
end

function loadWarehouseContents()
 dofile(SWS.filepath)
 
 local Airbases = world.getAirbases()
 
 for _, airbase in ipairs(Airbases) do

    local w=airbase:getWarehouse()
   
    local liquids = SWS.SimpleWarehouse[airbase:getName()]["liquids"]
    for liquidType, amountLiquid in pairs (liquids) do
      w:setLiquidAmount(liquidType, amountLiquid)
    end
    
    local weapons = SWS.SimpleWarehouse[airbase:getName()]["weapon"]
    for weaponName, amount in pairs(weapons) do
      w:setItem(weaponName, amount)
    end
        
    local aircraft = SWS.SimpleWarehouse[airbase:getName()]["aircraft"]
    for aircraftName, aircraftCount in pairs(aircraft) do
      w:setItem(aircraftName, aircraftCount)
    end 
 end
end

--START SCRIPT

if SWS.file_exists(SWS.filepath) then
  env.info("Loading Pikey's Simple Warehouse Saving - Save file exists, loading ...")
  loadWarehouseContents()
else
  env.info("Loading Pikey's Simple Warehouse Saving - save file does not exist, writing ...")
  saveWarehouseContents()
  serializeWarehouseContents()
  writeWarehouseContents()
end 

timer.scheduleFunction(saveWarehouseContents, {}, timer.getTime() + 1)
timer.scheduleFunction(serializeWarehouseContents, {}, timer.getTime() + 2)
timer.scheduleFunction(writeWarehouseContents, {}, timer.getTime() + 3)