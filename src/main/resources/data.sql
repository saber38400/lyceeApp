INSERT INTO users (user_fname, user_lname, user_email, user_pass, user_mobile, admin) VALUES
('Aadeesh','Jain','aadeeshjain.91a@yahoo.com','$2b$12$N67ZyJiAKm3oZh2DdE9Y6O1Pj19LB7wTEstxx36QnlOzsL9LffNPq','9876543212',false),
('Andrew','Jate','andrewjate.df@yahoo.com','$2b$12$OhJ1qCqnXDYyrdHDx3Q1Fuc11r7fbXyRyKnKhoKgLSHhFK.QzAivm','9876547542',false),
('John','Deed','john619.91a@yahoo.com','$2b$12$HJfJveyY38MJ5jKHNrWjGeYWO5m18BqTrQIyvvRos/mFHRGPlCZP.','9876544444',false),
('Peter','Parker','peter.parker@gmail.com','$2b$12$GEeX/0ywgsU4daw1WZNrze0gW1yhLdBH8tUQ6VZJchdgDxOBfSOb.','9871117542',false),
('Saber','Be','saber.be@gmail.com','$2b$12$OpvJHwajH9oDPMALYSXirO8jlVmHSurJVxyKVEDcpE2RrWgU4RyRm','9876232616',false);

INSERT INTO notes (student_email, subject, note_value, max_value, date_note) VALUES
('aadeeshjain.91a@yahoo.com','Mathématiques',15.5,20,'2026-06-10'),
('aadeeshjain.91a@yahoo.com','Français',12,20,'2026-06-12'),
('aadeeshjain.91a@yahoo.com','Histoire-Géographie',17,20,'2026-06-14'),
('andrewjate.df@yahoo.com','Mathématiques',9,20,'2026-06-10'),
('andrewjate.df@yahoo.com','Anglais',14,20,'2026-06-11'),
('saber.be@gmail.com','Mathématiques',18,20,'2026-06-10');

INSERT INTO schedule_slots (day_of_week, start_time, end_time, subject, lunch_break) VALUES
('Lundi','08:00','09:00','Mathématiques',false),
('Lundi','09:00','10:00','Français',false),
('Lundi','10:15','11:15','Histoire-Géographie',false),
('Lundi','11:15','12:00','Anglais',false),
('Lundi','12:00','13:00','Pause déjeuner',true),
('Lundi','13:00','14:00','SVT',false),
('Lundi','14:00','15:00','Physique-Chimie',false),
('Mardi','08:00','09:00','Anglais',false),
('Mardi','09:00','10:00','Mathématiques',false),
('Mardi','10:15','11:15','EPS',false),
('Mardi','12:00','13:00','Pause déjeuner',true),
('Mardi','13:00','14:00','Français',false),
('Mardi','14:00','15:00','SES',false),
('Mercredi','08:00','09:00','Physique-Chimie',false),
('Mercredi','09:00','10:00','Mathématiques',false),
('Mercredi','10:15','11:15','Histoire-Géographie',false),
('Jeudi','08:00','09:00','Français',false),
('Jeudi','09:00','10:00','SVT',false),
('Jeudi','10:15','11:15','Anglais',false),
('Jeudi','12:00','13:00','Pause déjeuner',true),
('Jeudi','13:00','14:00','Mathématiques',false),
('Jeudi','14:00','15:00','EPS',false),
('Vendredi','08:00','09:00','SES',false),
('Vendredi','09:00','10:00','Histoire-Géographie',false),
('Vendredi','10:15','11:15','Mathématiques',false),
('Vendredi','12:00','13:00','Pause déjeuner',true),
('Vendredi','13:00','14:00','Physique-Chimie',false);