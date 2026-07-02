with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;

procedure Mining_Outpost is
   type Oxygen_Capacity is range 1 .. 5;
   type Reactor_Temperature is range -5 .. 15;
   type Unidentified_Entity is range 5 .. 20;

   package Oxygen_Spike is new Ada.Numerics.Discrete_Random (Oxygen_Capacity);
   O2 : Oxygen_Spike.Generator;

   package Temperature_Spike is new
                  Ada.Numerics.Discrete_Random (Reactor_Temperature);
   Temperature : Temperature_Spike
                  .Generator;

   package Unknown_Creature_Distance is new
                  Ada.Numerics.Discrete_Random (Unidentified_Entity);
   Creature_Distance : Unknown_Creature_Distance.Generator;

   protected Life_Support is
      procedure Oxygen_Level (Oxygen : Integer; Capacity : Integer);
   end Life_Support;

   protected body Life_Support is
      procedure Oxygen_Level (Oxygen : Integer; Capacity : Integer) is
      begin
         if Oxygen > 20 then
            Put_Line ("Oxygen level: " & Integer'Image (Oxygen) & "%");
         end if;
      end Oxygen_Level;
   end Life_Support;

   task type Breathing (Oxygen : Integer; Capacity : Integer);

   task body Breathing is
      Current_Oxygen_Level : Integer := Capacity;
   begin
      Oxygen_Spike.Reset (O2);
      while Current_Oxygen_Level > 0 loop
         Life_Support.Oxygen_Level
                        (Current_Oxygen_Level, Capacity);
         Current_Oxygen_Level := Current_Oxygen_Level -
                                    Integer (Oxygen_Spike.Random (O2));
         if Current_Oxygen_Level in 1 .. 20 then
            Put_Line ("Warning! Oxygen level is critically low: " &
                        Integer'Image (Current_Oxygen_Level) & "%");
         elsif Current_Oxygen_Level <= 0 then
            Put_Line ("Oxygen level has dropped to " & Integer'Image
                        (Current_Oxygen_Level) & "%." &
                        "Executing system-wide lockdown.");
         end if;
         delay 2.0;
      end loop;
   end Breathing;

   protected Reactor_Status is
      procedure Temperature_Level (Temperature : Integer;
                                    Core_Fluctuation : Integer);
   end Reactor_Status;

   protected body Reactor_Status is
      procedure Temperature_Level (Temperature : Integer;
                                    Core_Fluctuation : Integer) is
      begin
         if Temperature in 1 .. 500 then
            Put_Line ("Reactor temperature: " &
                        Integer'Image (Temperature) & "°C");
         end if;
      end Temperature_Level;
   end Reactor_Status;

   task type Reactor (Temperature : Integer; Core_Fluctuation : Integer);

   task body Reactor is
      Current_Temperature : Integer := Core_Fluctuation;
   begin
      Temperature_Spike.Reset (Temperature);
      while True loop
         Reactor_Status.Temperature_Level
                           (Current_Temperature, Core_Fluctuation);
         Current_Temperature := Current_Temperature + Integer
                                 (Temperature_Spike.Random (Temperature));
         if Current_Temperature in 800 .. 999 then
            Put_Line ("Warning! Critical thermal temperature detected: " &
                        Integer'Image (Current_Temperature) & "°C");
         elsif Current_Temperature >= 100 then
            Put_Line ("Critical thermal temperature detected at " &
                        Integer'Image (Current_Temperature) & "°C." &
                        "Executing emergency shutdown.");
         end if;
         delay 1.0;
      end loop;
   end Reactor;

   Oxygen_Monitoring_System : Breathing (Oxygen => 100, Capacity => 100);
   Reactor_Monitoring_System : Reactor
                                 (Temperature => 100, Core_Fluctuation => 100);

begin
   Put_Line ("===== Ypsilon 14 Mining Outpost - " &
               "System Monitoring Online =====");
end Mining_Outpost;