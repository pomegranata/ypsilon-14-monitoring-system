with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;

procedure Mining_Outpost is

   --  Declaring the range types for oxygen capacity,
   --  reactor core temperature, and unidentified entity distance

   type Oxygen_Capacity is range 1 .. 5;
   type Reactor_Temperature is range -5 .. 15;
   type Unidentified_Entity is range 5 .. 20;

   --  Creating the random number generators for oxygen spikes,
   --  temperature fluctuations, and unidentified entity distances

   package Oxygen_Spike is new Ada.Numerics.Discrete_Random (Oxygen_Capacity);
   O2 : Oxygen_Spike.Generator;

   package Temperature_Spike is new
                  Ada.Numerics.Discrete_Random (Reactor_Temperature);
   Fluctuation : Temperature_Spike
                  .Generator;

   package Unknown_Entity is new
                  Ada.Numerics.Discrete_Random (Unidentified_Entity);
   Creature_Distance : Unknown_Entity.Generator;

   --  Creating the protected types of Main_Terminal as
   --  the main hub for printing all the tasks outputs

   protected Main_Terminal is
      procedure Oxygen_Level (Current_Oxygen_Level : Integer);
      procedure Temperature_Level (Current_Core_Temperature : Integer);
      procedure Entity_Proximity (Current_Distance : Integer);
   end Main_Terminal;

   protected body Main_Terminal is
      procedure Oxygen_Level (Current_Oxygen_Level : Integer) is
      begin
         if Current_Oxygen_Level in 1 .. 20 then
            Put_Line ("Warning! Oxygen level is critically low: " &
                        Integer'Image (Current_Oxygen_Level) & "%");
         elsif Current_Oxygen_Level <= 0 then
            Put_Line ("Oxygen level has dropped to " & Integer'Image
                        (Current_Oxygen_Level) & "%." &
                        "Executing system-wide lockdown.");
         end if;
      end Oxygen_Level;

      procedure Temperature_Level (Current_Core_Temperature : Integer) is
      begin
         if Current_Core_Temperature in 800 .. 999 then
            Put_Line ("Warning! Critical thermal temperature detected: " &
                        Integer'Image (Current_Core_Temperature) &
                        " Celsius.");
         elsif Current_Core_Temperature >= 1000 then
            Put_Line ("Critical thermal temperature detected at " &
                        Integer'Image (Current_Core_Temperature) &
                        " Celsius. Executing emergency shutdown.");
         end if;
      end Temperature_Level;

      procedure Entity_Proximity (Current_Distance : Integer) is
      begin
         if Current_Distance in 1 .. 29 then
            Put_Line ("Caution! Unidentified entity is approaching." &
                        " Current distance: " & Integer'Image
                              (Current_Distance) & " meters.");
         elsif Current_Distance <= 0 then
            Put_Line ("Unidentified entity has breached the control room. " &
                        "Sending out space marines to contain the threat.");
         end if;
      end Entity_Proximity;
   end Main_Terminal;

   --  Declaration of the protected types for
   --  Life_Support to monitor oxygen level

   protected Life_Support is
      procedure Oxygen_Level (Oxygen : Integer);
   end Life_Support;
   protected body Life_Support is
      procedure Oxygen_Level (Oxygen : Integer) is
      begin
         if Oxygen > 20 then
            Put_Line ("Oxygen level: " & Integer'Image (Oxygen) & "%");
         end if;
      end Oxygen_Level;
   end Life_Support;

   --  Declaration for the task types, starting with "Breathing"
   --  to calculate the oxygen level and printing the
   --  outputs based on the available capacity of the oxygen

   task type Breathing (Oxygen : Integer);

   task body Breathing is
      Current_Oxygen_Level : Integer := Oxygen;
   begin
      Oxygen_Spike.Reset (O2);
      while Current_Oxygen_Level > 0 loop
         Life_Support.Oxygen_Level
                        (Current_Oxygen_Level);
         Current_Oxygen_Level := Current_Oxygen_Level -
                                    Integer (Oxygen_Spike.Random (O2));
         Main_Terminal.Oxygen_Level (Current_Oxygen_Level);
         delay 2.0;
      end loop;
   end Breathing;

   --  Declaration of the protected types for
   --  Reactor_Status to monitor the reactor core temperature

   protected Reactor_Status is
      procedure Temperature_Level (Temperature : Integer);
   end Reactor_Status;

   protected body Reactor_Status is
      procedure Temperature_Level (Temperature : Integer) is
      begin
         if Temperature < 800 then
            Put_Line ("Reactor temperature: " &
                        Integer'Image (Temperature) & " Celcius");
         end if;
      end Temperature_Level;
   end Reactor_Status;

   --  Declaration for the task types, starting with "Reactor"
   --  to calculate the reactor core temperature and printing
   --  the outputs based on the available capacity
   --  of the reactor core temperature

   task type Reactor (Temperature : Integer);

   task body Reactor is
      Current_Core_Temperature : Integer := Temperature;
   begin
      Temperature_Spike.Reset (Fluctuation);
      while Current_Core_Temperature > 0 loop
         Reactor_Status.Temperature_Level
                           (Current_Core_Temperature);
         Current_Core_Temperature := Current_Core_Temperature + Integer
                                 (Temperature_Spike.Random (Fluctuation));
         Main_Terminal.Temperature_Level (Current_Core_Temperature);
      exit when Current_Core_Temperature >= 1000;
         delay 1.0;
      end loop;
   end Reactor;

   --  Declaration of the protected types for Entity_Distance
   --  to monitor the distance of the unidentified entity

   protected Entity_Distance is
      procedure Entity_Proximity (Distance : Integer);
   end Entity_Distance;

   protected body Entity_Distance is
      procedure Entity_Proximity (Distance : Integer) is
      begin
         if Distance > 30 then
            Put_Line ("Unidentified entity detected at: " &
                        Integer'Image (Distance) & " meters.");
         end if;
      end Entity_Proximity;
   end Entity_Distance;

   --  Declaration for the task types, starting with "Entity_Detection"
   --  to calculate the distance of the unidentified entity and printing
   --  the outputs based on the available distance of the unidentified entity

   task type Entity_Detection (Distance : Integer);

   task body Entity_Detection is
      Current_Distance : Integer := Distance;
   begin
      Unknown_Entity.Reset (Creature_Distance);
      while Current_Distance > 0 loop
         Entity_Distance.Entity_Proximity (Current_Distance);
         Current_Distance := Current_Distance - Integer
                              (Unknown_Entity.Random (Creature_Distance));
         Main_Terminal.Entity_Proximity (Current_Distance);
         delay 3.0;
      end loop;
   end Entity_Detection;

   --  Declaration of the tasks to monitor the oxygen level,
   --  reactor core temperature, and distance of the unidentified entity

   Oxygen_Monitoring_System : Breathing (Oxygen => 100);
   Reactor_Monitoring_System : Reactor (Temperature => 500);
   Entity_Monitoring_System : Entity_Detection (Distance => 100);

begin
   Put_Line ("===== Ypsilon 14 Mining Outpost - " &
               "System Monitoring Online =====");
end Mining_Outpost;