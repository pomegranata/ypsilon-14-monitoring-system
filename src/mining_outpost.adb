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

   package Unknown_Entity is new
                  Ada.Numerics.Discrete_Random (Unidentified_Entity);
   Creature_Distance : Unknown_Entity.Generator;

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
         if Temperature < 800 then
            Put_Line ("Reactor temperature: " &
                        Integer'Image (Temperature) & "°C");
         end if;
      end Temperature_Level;
   end Reactor_Status;

   task type Reactor (Core_Temperature : Integer; Core_Fluctuation : Integer);

   task body Reactor is
      Current_Temperature : Integer := Core_Fluctuation;
   begin
      Temperature_Spike.Reset (Temperature);
      while Current_Temperature > 0 loop
         Reactor_Status.Temperature_Level
                           (Current_Temperature, Core_Fluctuation);
         Current_Temperature := Current_Temperature + Integer
                                 (Temperature_Spike.Random (Temperature));
         if Current_Temperature in 800 .. 999 then
            Put_Line ("Warning! Critical thermal temperature detected: " &
                        Integer'Image (Current_Temperature) & "Celsius.");
         elsif Current_Temperature in 1000 .. 1014 then
            Put_Line ("Critical thermal temperature detected at " &
                        Integer'Image (Current_Temperature) & "Celsius." &
                        "Executing emergency shutdown.");
         end if;
         delay 1.0;
      end loop;
   end Reactor;

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

   task type Entity_Detection (Distance : Integer);

   task body Entity_Detection is
      Current_Distance : Integer := Distance;
   begin
      Unknown_Entity.Reset (Creature_Distance);
      while Current_Distance > 0 loop
         Entity_Distance.Entity_Proximity (Current_Distance);
         Current_Distance := Current_Distance - Integer
                              (Unknown_Entity.Random (Creature_Distance));
         if Current_Distance in 1 .. 29 then
            Put_Line ("Caution! Unidentified entity is approaching." &
                        " Current distance: " & Integer'Image
                              (Current_Distance) & " meters.");
         elsif Current_Distance <= 0 then
            Put_Line ("Unidentified entity has breached the control room. " &
                        "Sending out space marines to contain the threat.");
         end if;
         delay 3.0;
      end loop;
   end Entity_Detection;

   protected Main_Terminal is
      procedure Oxygen_Level (Oxygen : Integer; Capacity : Integer);
      procedure Temperature_Level (Temperature : Integer;
                                    Core_Fluctuation : Integer);
      procedure Entity_Proximity (Distance : Integer);
   end Main_Terminal;

   protected body Main_Terminal is
      procedure Oxygen_Level (Oxygen : Integer; Capacity : Integer) is
      begin
         if Oxygen > 20 then
            Put_Line ("Oxygen level: " & Integer'Image (Oxygen) & "%");
         end if;
      end Oxygen_Level;

      procedure Temperature_Level (Temperature : Integer;
                                    Core_Fluctuation : Integer) is
      begin
         if Temperature >= 500 then
            Put_Line ("Reactor temperature: " &
                        Integer'Image (Temperature) & "Celsius.");
         end if;
      end Temperature_Level;

      procedure Entity_Proximity (Distance : Integer) is
      begin
         if Distance > 30 then
            Put_Line ("Unidentified entity detected at: " &
                        Integer'Image (Distance) & " meters.");
         end if;
      end Entity_Proximity;
   end Main_Terminal;

   Reactor_Monitoring_System : Reactor (Core_Temperature => 500,
                                 Core_Fluctuation => 500);
   Oxygen_Monitoring_System : Breathing (Oxygen => 100, Capacity => 100);
   Entity_Monitoring_System : Entity_Detection (Distance => 100);

begin
   Put_Line ("===== Ypsilon 14 Mining Outpost - " &
               "System Monitoring Online =====");
end Mining_Outpost;