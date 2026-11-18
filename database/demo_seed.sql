-- BPAMIS demo database
-- Every person, address, phone number, email and case below is invented for demonstration.
-- All demo accounts share one password, documented in README.md. It is not used anywhere real.
-- Dates are relative to the day of import, so hearings stay upcoming after a fresh import.
-- Import into an empty database, for example with phpMyAdmin > Import.

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET FOREIGN_KEY_CHECKS = 0;
SET time_zone = "+08:00";
SET NAMES utf8mb4;

-- Schema

CREATE TABLE `arbitration` (
  `Arbitration_ID` int(11) NOT NULL,
  `Case_ID` int(11) NOT NULL,
  `Arbitration_Date` date NOT NULL,
  `Deadline` date NOT NULL,
  `Remarks` text DEFAULT NULL,
  `Created_At` timestamp NOT NULL DEFAULT current_timestamp(),
  `mediator_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `barangay_officials` (
  `Official_ID` int(11) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `Position` varchar(50) DEFAULT NULL,
  `Contact_Number` varchar(20) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `official_username` varchar(100) DEFAULT NULL,
  `isActive` tinyint(1) DEFAULT 0,
  `email` varchar(255) DEFAULT NULL,
  `Birthdate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `blotter_info` (
  `Blotter_ID` int(11) NOT NULL,
  `Case_ID` int(11) DEFAULT NULL,
  `Blotter_Description` text DEFAULT NULL,
  `Reported_By` varchar(100) DEFAULT NULL,
  `Date_Reported` date DEFAULT NULL,
  `Complaint_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `brgy_captain` (
  `Captain_ID` int(11) NOT NULL,
  `Official_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `brgy_secretary` (
  `Secretary_ID` int(11) NOT NULL,
  `Official_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `case_info` (
  `Case_ID` int(11) NOT NULL,
  `case_original_id` varchar(191) DEFAULT NULL,
  `Complaint_ID` int(11) DEFAULT NULL,
  `Case_Status` varchar(50) DEFAULT NULL,
  `Certificate_Path` varchar(512) DEFAULT NULL,
  `Date_Opened` datetime DEFAULT NULL,
  `Date_Closed` datetime DEFAULT NULL,
  `Next_Hearing_Date` date DEFAULT NULL,
  `lupon_assign` varchar(255) DEFAULT NULL,
  `Case_Deadline` date DEFAULT NULL,
  `Deadline_Overdue` tinyint(1) DEFAULT 0,
  `case_number` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Dismiss_Reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `case_participants` (
  `Participant_ID` int(11) NOT NULL,
  `Case_ID` int(11) DEFAULT NULL,
  `Resident_ID` int(11) DEFAULT NULL,
  `Participant_Role` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `case_process` (
  `Process_ID` int(11) NOT NULL,
  `Case_ID` int(11) DEFAULT NULL,
  `Process_Details` text DEFAULT NULL,
  `Date_Processed` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `case_types` (
  `Type_ID` int(11) NOT NULL,
  `Case_Type` varchar(191) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `complaint_history` (
  `History_ID` int(11) NOT NULL,
  `Complaint_ID` int(11) NOT NULL,
  `Old_Title` varchar(512) DEFAULT NULL,
  `Old_Details` text DEFAULT NULL,
  `Edited_By` varchar(191) DEFAULT NULL,
  `Edited_At` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `complaint_info` (
  `Complaint_ID` int(11) NOT NULL,
  `incident_date` date DEFAULT NULL,
  `incident_time` time DEFAULT NULL,
  `Resident_ID` int(11) DEFAULT NULL,
  `Complaint_Title` varchar(255) DEFAULT NULL,
  `Respondent_Name` varchar(255) DEFAULT NULL,
  `Complaint_Details` text DEFAULT NULL,
  `Date_Filed` date DEFAULT NULL,
  `Status` varchar(50) DEFAULT NULL,
  `Respondent_ID` int(11) DEFAULT NULL,
  `Complaint_Type` varchar(100) DEFAULT NULL,
  `Attachment_Path` varchar(255) DEFAULT NULL,
  `external_complainant_id` int(11) DEFAULT NULL,
  `external_complainant_agree` tinyint(1) DEFAULT 0,
  `case_type` varchar(255) DEFAULT NULL,
  `complainant_agree` tinyint(1) DEFAULT 0,
  `respondent_agree` tinyint(1) DEFAULT 0,
  `Salaysay_Path` varchar(1024) DEFAULT NULL,
  `dismissal_reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `complaint_info_history` (
  `id` int(11) NOT NULL,
  `complaint_id` int(11) NOT NULL,
  `version_number` int(11) NOT NULL,
  `details` text NOT NULL,
  `updated_by` varchar(100) DEFAULT NULL,
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `complaint_respondents` (
  `id` int(11) NOT NULL,
  `complaint_id` int(11) NOT NULL,
  `respondent_id` int(11) NOT NULL,
  `respondent_agree` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `conciliation` (
  `Conciliation_ID` int(11) NOT NULL,
  `Case_ID` int(11) NOT NULL,
  `Conciliation_Date` date NOT NULL,
  `Deadline` date NOT NULL,
  `Remarks` text DEFAULT NULL,
  `Created_At` datetime DEFAULT current_timestamp(),
  `mediator_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `external_complainant` (
  `External_Complaint_ID` int(11) NOT NULL,
  `First_Name` varchar(50) DEFAULT NULL,
  `Middle_Name` varchar(50) DEFAULT NULL,
  `Last_Name` varchar(50) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `Contact_Number` varchar(20) DEFAULT NULL,
  `Birthdate` date DEFAULT NULL,
  `isActive` tinyint(1) NOT NULL,
  `email` varchar(60) NOT NULL,
  `password` varchar(255) NOT NULL,
  `External_Username` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `feedback` (
  `id` int(11) NOT NULL,
  `official_id` int(11) DEFAULT NULL,
  `official_name` varchar(255) DEFAULT NULL,
  `message` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `case_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `mediation_info` (
  `Mediation_ID` int(11) NOT NULL,
  `Case_ID` int(11) DEFAULT NULL,
  `Mediator_Name` varchar(100) DEFAULT NULL,
  `Mediation_Date` date DEFAULT NULL,
  `Mediation_Result` text DEFAULT NULL,
  `Deadline` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `meeting_logs` (
  `Log_ID` int(11) NOT NULL,
  `Case_ID` int(11) NOT NULL,
  `Hearing_Date` date NOT NULL,
  `Hearing_Time` time NOT NULL,
  `Hearing_Details` text NOT NULL,
  `Created_At` timestamp NOT NULL DEFAULT current_timestamp(),
  `Hearing_End_Time` time DEFAULT NULL,
  `Complainant_Status` varchar(50) DEFAULT NULL,
  `Respondent_Status` varchar(50) DEFAULT NULL,
  `Attendance` text DEFAULT NULL,
  `Reason_Incompliance` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL,
  `resident_id` int(11) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `is_read` tinyint(1) DEFAULT 0,
  `related_id` int(11) DEFAULT NULL,
  `external_complaint_id` int(11) DEFAULT NULL,
  `official_id` int(11) DEFAULT NULL,
  `isPriority` tinyint(1) NOT NULL,
  `lupon_id` int(11) DEFAULT NULL,
  `is_read_captain` tinyint(1) NOT NULL DEFAULT 0,
  `is_read_secretary` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `notifications_delivered` (
  `id` int(11) NOT NULL,
  `notification_id` int(11) NOT NULL,
  `resident_id` int(11) DEFAULT NULL,
  `official_id` int(11) DEFAULT NULL,
  `lupon_id` int(11) DEFAULT NULL,
  `external_complaint_id` int(11) DEFAULT NULL,
  `delivered_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `notifications_trash` (
  `notification_id` int(11) NOT NULL,
  `type` varchar(128) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `related_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `is_read_secretary` tinyint(1) DEFAULT NULL,
  `isPriority` tinyint(1) DEFAULT 0,
  `trashed_at` datetime NOT NULL DEFAULT current_timestamp(),
  `trashed_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `official_profile` (
  `Official_ID` int(11) NOT NULL,
  `address` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `official_schedule` (
  `Official_ID` int(11) NOT NULL,
  `duty_days` varchar(100) DEFAULT NULL,
  `time_in` varchar(10) DEFAULT NULL,
  `time_out` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `password_resets` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `otp_hash` varchar(255) NOT NULL,
  `expires_at` datetime NOT NULL,
  `used` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `peace_keeper` (
  `PeaceKeeper_ID` int(11) NOT NULL,
  `Official_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `resident_info` (
  `Resident_ID` int(11) NOT NULL,
  `First_Name` varchar(50) DEFAULT NULL,
  `Middle_Name` varchar(50) DEFAULT NULL,
  `Last_Name` varchar(50) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `Contact_Number` varchar(20) DEFAULT NULL,
  `Birthdate` date DEFAULT NULL,
  `Resident_Username` varchar(20) NOT NULL,
  `Password` varchar(225) NOT NULL,
  `isVerify` tinyint(1) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `valid_id_path` varchar(255) NOT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT 0,
  `age` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `resolution` (
  `Resolution_ID` int(11) NOT NULL,
  `Case_ID` int(11) DEFAULT NULL,
  `Mediator_Name` varchar(100) DEFAULT NULL,
  `Resolution_Details` text DEFAULT NULL,
  `Resolution_Date` date DEFAULT NULL,
  `Deadline` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `schedule_list` (
  `hearingID` int(11) NOT NULL,
  `visible` int(11) NOT NULL DEFAULT 1,
  `selectedCase` int(11) DEFAULT NULL,
  `hearingTitle` varchar(100) NOT NULL,
  `hearingDateTime` datetime NOT NULL,
  `place` varchar(100) NOT NULL,
  `participant` text NOT NULL,
  `remarks` text DEFAULT 'N/A',
  `Case_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `settlement` (
  `Settlement_ID` int(11) NOT NULL,
  `Case_ID` int(11) DEFAULT NULL,
  `Mediator_Name` varchar(100) DEFAULT NULL,
  `Settlement_Details` text DEFAULT NULL,
  `Date_Agreed` date DEFAULT NULL,
  `Deadline` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `site_settings` (
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `arbitration`
  ADD PRIMARY KEY (`Arbitration_ID`),
  ADD KEY `fk_arbitration_case` (`Case_ID`);

ALTER TABLE `barangay_officials`
  ADD PRIMARY KEY (`Official_ID`);

ALTER TABLE `blotter_info`
  ADD PRIMARY KEY (`Blotter_ID`),
  ADD KEY `blotter_info_ibfk_1` (`Case_ID`),
  ADD KEY `fk_blotter_complaint` (`Complaint_ID`);

ALTER TABLE `brgy_captain`
  ADD PRIMARY KEY (`Captain_ID`),
  ADD KEY `Official_ID` (`Official_ID`);

ALTER TABLE `brgy_secretary`
  ADD PRIMARY KEY (`Secretary_ID`),
  ADD KEY `Official_ID` (`Official_ID`);

ALTER TABLE `case_info`
  ADD PRIMARY KEY (`Case_ID`),
  ADD UNIQUE KEY `case_original_id` (`case_original_id`),
  ADD KEY `Complaint_ID` (`Complaint_ID`);

ALTER TABLE `case_participants`
  ADD PRIMARY KEY (`Participant_ID`),
  ADD KEY `Resident_ID` (`Resident_ID`),
  ADD KEY `case_participants_ibfk_1` (`Case_ID`);

ALTER TABLE `case_process`
  ADD PRIMARY KEY (`Process_ID`),
  ADD KEY `case_process_ibfk_1` (`Case_ID`);

ALTER TABLE `case_types`
  ADD PRIMARY KEY (`Type_ID`),
  ADD UNIQUE KEY `Case_Type` (`Case_Type`);

ALTER TABLE `complaint_history`
  ADD PRIMARY KEY (`History_ID`),
  ADD KEY `Complaint_ID` (`Complaint_ID`),
  ADD KEY `Edited_At` (`Edited_At`);

ALTER TABLE `complaint_info`
  ADD PRIMARY KEY (`Complaint_ID`),
  ADD KEY `Resident_ID` (`Resident_ID`),
  ADD KEY `fk_complaint_external` (`external_complainant_id`);

ALTER TABLE `complaint_info_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `complaint_id` (`complaint_id`);

ALTER TABLE `complaint_respondents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `complaint_id` (`complaint_id`),
  ADD KEY `respondent_id` (`respondent_id`);

ALTER TABLE `conciliation`
  ADD PRIMARY KEY (`Conciliation_ID`);

ALTER TABLE `external_complainant`
  ADD PRIMARY KEY (`External_Complaint_ID`);

ALTER TABLE `feedback`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `mediation_info`
  ADD PRIMARY KEY (`Mediation_ID`),
  ADD KEY `mediation_info_ibfk_1` (`Case_ID`);

ALTER TABLE `meeting_logs`
  ADD PRIMARY KEY (`Log_ID`),
  ADD KEY `meeting_logs_ibfk_1` (`Case_ID`);

ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `resident_id` (`resident_id`),
  ADD KEY `fk_external` (`external_complaint_id`);

ALTER TABLE `notifications_delivered`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ux_notification_user` (`notification_id`,`resident_id`,`official_id`,`lupon_id`,`external_complaint_id`);

ALTER TABLE `notifications_trash`
  ADD PRIMARY KEY (`notification_id`);

ALTER TABLE `official_profile`
  ADD PRIMARY KEY (`Official_ID`);

ALTER TABLE `official_schedule`
  ADD PRIMARY KEY (`Official_ID`);

ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `email` (`email`),
  ADD KEY `expires_at` (`expires_at`);

ALTER TABLE `peace_keeper`
  ADD PRIMARY KEY (`PeaceKeeper_ID`),
  ADD KEY `Official_ID` (`Official_ID`);

ALTER TABLE `resident_info`
  ADD PRIMARY KEY (`Resident_ID`),
  ADD UNIQUE KEY `email` (`email`);

ALTER TABLE `resolution`
  ADD PRIMARY KEY (`Resolution_ID`),
  ADD KEY `resolution_ibfk_1` (`Case_ID`);

ALTER TABLE `schedule_list`
  ADD PRIMARY KEY (`hearingID`),
  ADD KEY `fk_schedule_case` (`Case_ID`);

ALTER TABLE `settlement`
  ADD PRIMARY KEY (`Settlement_ID`),
  ADD KEY `settlement_ibfk_1` (`Case_ID`);

ALTER TABLE `site_settings`
  ADD PRIMARY KEY (`setting_key`);

ALTER TABLE `arbitration`
  MODIFY `Arbitration_ID` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `barangay_officials`
  MODIFY `Official_ID` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `blotter_info`
  MODIFY `Blotter_ID` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `brgy_captain`
  MODIFY `Captain_ID` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `brgy_secretary`
  MODIFY `Secretary_ID` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `case_info`
  MODIFY `Case_ID` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `case_participants`
  MODIFY `Participant_ID` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `case_process`
  MODIFY `Process_ID` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `case_types`
  MODIFY `Type_ID` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `complaint_history`
  MODIFY `History_ID` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `complaint_info`
  MODIFY `Complaint_ID` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `complaint_info_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `complaint_respondents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `conciliation`
  MODIFY `Conciliation_ID` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `external_complainant`
  MODIFY `External_Complaint_ID` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `mediation_info`
  MODIFY `Mediation_ID` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `meeting_logs`
  MODIFY `Log_ID` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `notifications_delivered`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `official_profile`
  MODIFY `Official_ID` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `official_schedule`
  MODIFY `Official_ID` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `password_resets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `peace_keeper`
  MODIFY `PeaceKeeper_ID` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `resident_info`
  MODIFY `Resident_ID` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `resolution`
  MODIFY `Resolution_ID` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `schedule_list`
  MODIFY `hearingID` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `settlement`
  MODIFY `Settlement_ID` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `arbitration`
  ADD CONSTRAINT `fk_arbitration_case` FOREIGN KEY (`Case_ID`) REFERENCES `case_info` (`Case_ID`) ON DELETE CASCADE;

ALTER TABLE `blotter_info`
  ADD CONSTRAINT `blotter_info_ibfk_1` FOREIGN KEY (`Case_ID`) REFERENCES `case_info` (`Case_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_blotter_complaint` FOREIGN KEY (`Complaint_ID`) REFERENCES `complaint_info` (`Complaint_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `brgy_captain`
  ADD CONSTRAINT `brgy_captain_ibfk_1` FOREIGN KEY (`Official_ID`) REFERENCES `barangay_officials` (`Official_ID`);

ALTER TABLE `brgy_secretary`
  ADD CONSTRAINT `brgy_secretary_ibfk_1` FOREIGN KEY (`Official_ID`) REFERENCES `barangay_officials` (`Official_ID`);

ALTER TABLE `case_participants`
  ADD CONSTRAINT `case_participants_ibfk_1` FOREIGN KEY (`Case_ID`) REFERENCES `case_info` (`Case_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `case_participants_ibfk_2` FOREIGN KEY (`Resident_ID`) REFERENCES `resident_info` (`Resident_ID`);

ALTER TABLE `complaint_info_history`
  ADD CONSTRAINT `complaint_info_history_ibfk_1` FOREIGN KEY (`complaint_id`) REFERENCES `complaint_info` (`Complaint_ID`);

CREATE TABLE `rate_limits` (
  `rate_key` char(64) NOT NULL,
  `hits` int(11) NOT NULL DEFAULT 0,
  `window_start` int(11) NOT NULL,
  PRIMARY KEY (`rate_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Fictional data

INSERT INTO `barangay_officials` (`Official_ID`, `Name`, `Position`, `Contact_Number`, `password`, `official_username`, `isActive`, `email`, `Birthdate`) VALUES
  (1, 'Maria Dalisay Santos', 'Barangay Secretary', '0900-000-0001', '$2y$10$ST5URa5X.meAb7dQpt1tLOKEXSJJ3M.Ldm.7byGjSt9oYD3PkN5yO', 'demo_secretary', 1, 'secretary@example.com', '1985-03-14'),
  (2, 'Ramon Bayani Cruz', 'Lupon Head', '0900-000-0002', '$2y$10$ST5URa5X.meAb7dQpt1tLOKEXSJJ3M.Ldm.7byGjSt9oYD3PkN5yO', 'demo_luponhead', 1, 'luponhead@example.com', '1972-07-21'),
  (3, 'Eduardo Magtanggol Reyes', 'Barangay Captain', '0900-000-0003', '$2y$10$ST5URa5X.meAb7dQpt1tLOKEXSJJ3M.Ldm.7byGjSt9oYD3PkN5yO', 'demo_captain', 1, 'captain@example.com', '1968-11-02'),
  (4, 'Teresita Liwanag Ramos', 'Lupon Tagapamayapa', '0900-000-0004', '$2y$10$ST5URa5X.meAb7dQpt1tLOKEXSJJ3M.Ldm.7byGjSt9oYD3PkN5yO', 'demo_lupon', 1, 'lupon@example.com', '1979-01-30'),
  (5, 'Crisanto Mabini Flores', 'Lupon Tagapamayapa', '0900-000-0005', '$2y$10$ST5URa5X.meAb7dQpt1tLOKEXSJJ3M.Ldm.7byGjSt9oYD3PkN5yO', 'demo_lupon2', 1, 'lupon2@example.com', '1975-05-09');

INSERT INTO `brgy_secretary` (`Secretary_ID`, `Official_ID`) VALUES
  (1, 1);

INSERT INTO `brgy_captain` (`Captain_ID`, `Official_ID`) VALUES
  (1, 3);

INSERT INTO `peace_keeper` (`PeaceKeeper_ID`, `Official_ID`) VALUES
  (1, 2),
  (2, 4),
  (3, 5);

INSERT INTO `official_profile` (`Official_ID`, `address`) VALUES
  (1, 'Purok 1, Barangay Halimbawa, Bayan ng Sampaguita'),
  (2, 'Purok 2, Barangay Halimbawa, Bayan ng Sampaguita'),
  (3, 'Purok 3, Barangay Halimbawa, Bayan ng Sampaguita'),
  (4, 'Purok 4, Barangay Halimbawa, Bayan ng Sampaguita'),
  (5, 'Purok 5, Barangay Halimbawa, Bayan ng Sampaguita');

INSERT INTO `official_schedule` (`Official_ID`, `duty_days`, `time_in`, `time_out`) VALUES
  (1, 'Mon,Tue,Wed,Thu,Fri', '08:00', '17:00'),
  (2, 'Mon,Tue,Wed,Thu,Fri', '08:00', '17:00'),
  (3, 'Mon,Tue,Wed,Thu,Fri', '08:00', '17:00'),
  (4, 'Mon,Tue,Wed,Thu,Fri', '08:00', '17:00'),
  (5, 'Mon,Tue,Wed,Thu,Fri', '08:00', '17:00');

INSERT INTO `resident_info` (`Resident_ID`, `First_Name`, `Middle_Name`, `Last_Name`, `Address`, `Contact_Number`, `Birthdate`, `Resident_Username`, `Password`, `isVerify`, `email`, `valid_id_path`, `isActive`, `age`) VALUES
  (1, 'Juana', 'Bautista', 'Dela Cruz', 'Purok 1, Barangay Halimbawa, Bayan ng Sampaguita', '0900-100-0001', '1970-01-15', 'resident', '$2y$10$ST5URa5X.meAb7dQpt1tLOKEXSJJ3M.Ldm.7byGjSt9oYD3PkN5yO', 1, 'resident@example.com', 'Assets/Img/demo_valid_id.png', 1, '56'),
  (2, 'Pedro', 'Agoncillo', 'Villanueva', 'Purok 2, Barangay Halimbawa, Bayan ng Sampaguita', '0900-100-0002', '1971-02-15', 'pedro.v', '$2y$10$ST5URa5X.meAb7dQpt1tLOKEXSJJ3M.Ldm.7byGjSt9oYD3PkN5yO', 1, 'pedro.v@example.com', 'Assets/Img/demo_valid_id.png', 1, '55'),
  (3, 'Liza', 'Mercado', 'Pascual', 'Purok 3, Barangay Halimbawa, Bayan ng Sampaguita', '0900-100-0003', '1972-03-15', 'liza.p', '$2y$10$ST5URa5X.meAb7dQpt1tLOKEXSJJ3M.Ldm.7byGjSt9oYD3PkN5yO', 1, 'liza.p@example.com', 'Assets/Img/demo_valid_id.png', 1, '54'),
  (4, 'Andres', 'Salazar', 'Navarro', 'Purok 4, Barangay Halimbawa, Bayan ng Sampaguita', '0900-100-0004', '1973-04-15', 'andres.n', '$2y$10$ST5URa5X.meAb7dQpt1tLOKEXSJJ3M.Ldm.7byGjSt9oYD3PkN5yO', 1, 'andres.n@example.com', 'Assets/Img/demo_valid_id.png', 1, '53'),
  (5, 'Rosario', 'Tolentino', 'Aquino', 'Purok 5, Barangay Halimbawa, Bayan ng Sampaguita', '0900-100-0005', '1974-05-15', 'rosario.a', '$2y$10$ST5URa5X.meAb7dQpt1tLOKEXSJJ3M.Ldm.7byGjSt9oYD3PkN5yO', 1, 'rosario.a@example.com', 'Assets/Img/demo_valid_id.png', 1, '52'),
  (6, 'Marites', 'Domingo', 'Garcia', 'Purok 6, Barangay Halimbawa, Bayan ng Sampaguita', '0900-100-0006', '1975-06-15', 'marites.g', '$2y$10$ST5URa5X.meAb7dQpt1tLOKEXSJJ3M.Ldm.7byGjSt9oYD3PkN5yO', 1, 'marites.g@example.com', 'Assets/Img/demo_valid_id.png', 1, '51'),
  (7, 'Jose', 'Lacson', 'Mendoza', 'Purok 1, Barangay Halimbawa, Bayan ng Sampaguita', '0900-100-0007', '1976-07-15', 'jose.m', '$2y$10$ST5URa5X.meAb7dQpt1tLOKEXSJJ3M.Ldm.7byGjSt9oYD3PkN5yO', 1, 'jose.m@example.com', 'Assets/Img/demo_valid_id.png', 1, '50'),
  (8, 'Corazon', 'Valdez', 'Torres', 'Purok 2, Barangay Halimbawa, Bayan ng Sampaguita', '0900-100-0008', '1977-08-15', 'corazon.t', '$2y$10$ST5URa5X.meAb7dQpt1tLOKEXSJJ3M.Ldm.7byGjSt9oYD3PkN5yO', 1, 'corazon.t@example.com', 'Assets/Img/demo_valid_id.png', 1, '49'),
  (9, 'Danilo', 'Ocampo', 'Castillo', 'Purok 3, Barangay Halimbawa, Bayan ng Sampaguita', '0900-100-0009', '1978-09-15', 'danilo.c', '$2y$10$ST5URa5X.meAb7dQpt1tLOKEXSJJ3M.Ldm.7byGjSt9oYD3PkN5yO', 1, 'danilo.c@example.com', 'Assets/Img/demo_valid_id.png', 1, '48'),
  (10, 'Imelda', 'Rivera', 'Fernandez', 'Purok 4, Barangay Halimbawa, Bayan ng Sampaguita', '0900-100-0010', '1979-01-15', 'imelda.f', '$2y$10$ST5URa5X.meAb7dQpt1tLOKEXSJJ3M.Ldm.7byGjSt9oYD3PkN5yO', 1, 'imelda.f@example.com', 'Assets/Img/demo_valid_id.png', 1, '47'),
  (11, 'Nestor', 'Bernardo', 'Gonzales', 'Purok 5, Barangay Halimbawa, Bayan ng Sampaguita', '0900-100-0011', '1980-02-15', 'nestor.g', '$2y$10$ST5URa5X.meAb7dQpt1tLOKEXSJJ3M.Ldm.7byGjSt9oYD3PkN5yO', 0, 'nestor.g@example.com', 'Assets/Img/demo_valid_id.png', 0, '46'),
  (12, 'Ligaya', 'Santiago', 'Soriano', 'Purok 6, Barangay Halimbawa, Bayan ng Sampaguita', '0900-100-0012', '1981-03-15', 'ligaya.s', '$2y$10$ST5URa5X.meAb7dQpt1tLOKEXSJJ3M.Ldm.7byGjSt9oYD3PkN5yO', 1, 'ligaya.s@example.com', 'Assets/Img/demo_valid_id.png', 0, '45');

INSERT INTO `external_complainant` (`External_Complaint_ID`, `First_Name`, `Middle_Name`, `Last_Name`, `Address`, `Contact_Number`, `Birthdate`, `isActive`, `email`, `password`, `External_Username`) VALUES
  (1, 'Roberto', 'Sison', 'Alcantara', 'Barangay Maligaya, Bayan ng Sampaguita', '0900-200-0001', '1980-02-11', 1, 'external@example.com', '$2y$10$ST5URa5X.meAb7dQpt1tLOKEXSJJ3M.Ldm.7byGjSt9oYD3PkN5yO', 'demo_external'),
  (2, 'Evelyn', 'Manalo', 'Salonga', 'Barangay Masagana, Bayan ng Sampaguita', '0900-200-0002', '1983-09-25', 1, 'evelyn.s@example.com', '$2y$10$ST5URa5X.meAb7dQpt1tLOKEXSJJ3M.Ldm.7byGjSt9oYD3PkN5yO', 'evelyn_s'),
  (3, 'Gregorio', 'Abad', 'Pineda', 'Barangay Mapayapa, Bayan ng Sampaguita', '0900-200-0003', '1977-12-05', 0, 'gregorio.p@example.com', '$2y$10$ST5URa5X.meAb7dQpt1tLOKEXSJJ3M.Ldm.7byGjSt9oYD3PkN5yO', 'gregorio_p');

INSERT INTO `case_types` (`Type_ID`, `Case_Type`) VALUES
  (1, 'Civil'),
  (2, 'Criminal'),
  (3, 'Blotter'),
  (4, 'Others');

INSERT INTO `complaint_info` (`Complaint_ID`, `incident_date`, `incident_time`, `Resident_ID`, `Complaint_Title`, `Respondent_Name`, `Complaint_Details`, `Date_Filed`, `Status`, `Respondent_ID`, `Complaint_Type`, `external_complainant_id`, `external_complainant_agree`, `case_type`, `complainant_agree`, `respondent_agree`, `dismissal_reason`) VALUES
  (1, (CURDATE() - INTERVAL 64 DAY), '18:30:00', 1, 'Unpaid borrowed money', 'Pedro Agoncillo Villanueva', 'Complainant says a personal loan of 5,000 pesos was not repaid on the agreed date.', (CURDATE() - INTERVAL 62 DAY), 'In Case', 2, 'Civil', NULL, 0, 'civil', 1, 1, NULL),
  (2, (CURDATE() - INTERVAL 57 DAY), '18:30:00', 3, 'Boundary fence dispute', 'Andres Salazar Navarro', 'Neighbor built a fence that allegedly crosses the shared property line.', (CURDATE() - INTERVAL 55 DAY), 'In Case', 4, 'Civil', NULL, 0, 'civil', 1, 1, NULL),
  (3, (CURDATE() - INTERVAL 50 DAY), '18:30:00', 5, 'Loud karaoke at night', 'Marites Domingo Garcia', 'Repeated loud karaoke past 10 PM is disturbing the household next door.', (CURDATE() - INTERVAL 48 DAY), 'In Case', 6, 'Others', NULL, 0, 'civil', 1, 1, NULL),
  (4, (CURDATE() - INTERVAL 46 DAY), '18:30:00', 7, 'Damaged motorcycle side mirror', 'Corazon Valdez Torres', 'Respondent allegedly broke a side mirror during an argument over parking.', (CURDATE() - INTERVAL 44 DAY), 'In Case', 8, 'Criminal', NULL, 0, 'criminal', 1, 1, NULL),
  (5, (CURDATE() - INTERVAL 42 DAY), '18:30:00', 9, 'Stray dog bite incident', 'Imelda Rivera Fernandez', 'Complainant was bitten by a dog that the respondent keeps unleashed.', (CURDATE() - INTERVAL 40 DAY), 'In Case', 10, 'Civil', NULL, 0, 'civil', 1, 1, NULL),
  (6, (CURDATE() - INTERVAL 38 DAY), '18:30:00', 2, 'Unpaid house rent', 'Liza Mercado Pascual', 'Tenant has not paid two months of rent for a small room.', (CURDATE() - INTERVAL 36 DAY), 'In Case', 3, 'Civil', NULL, 0, 'civil', 1, 1, NULL),
  (7, (CURDATE() - INTERVAL 34 DAY), '18:30:00', 4, 'Clogged shared drainage', 'Rosario Tolentino Aquino', 'Respondent''s construction debris blocks the shared drainage canal.', (CURDATE() - INTERVAL 32 DAY), 'In Case', 5, 'Civil', NULL, 0, 'civil', 1, 1, NULL),
  (8, (CURDATE() - INTERVAL 30 DAY), '18:30:00', 6, 'Verbal threats between neighbors', 'Jose Lacson Mendoza', 'Complainant reports repeated verbal threats after a family argument.', (CURDATE() - INTERVAL 28 DAY), 'In Case', 7, 'Criminal', NULL, 0, 'criminal', 1, 1, NULL),
  (9, (CURDATE() - INTERVAL 26 DAY), '18:30:00', 8, 'Unreturned borrowed tools', 'Danilo Ocampo Castillo', 'Carpentry tools were borrowed and never returned.', (CURDATE() - INTERVAL 24 DAY), 'In Case', 9, 'Civil', NULL, 0, 'civil', 1, 1, NULL),
  (10, (CURDATE() - INTERVAL 22 DAY), '18:30:00', NULL, 'Delivery payment dispute', 'Juana Bautista Dela Cruz', 'External complainant says goods were delivered but never paid for.', (CURDATE() - INTERVAL 20 DAY), 'In Case', 1, 'Civil', 1, 0, 'civil', 1, 1, NULL),
  (11, (CURDATE() - INTERVAL 18 DAY), '18:30:00', 10, 'Tree branches over property line', 'Juana Bautista Dela Cruz', 'Overhanging branches keep damaging the complainant''s roof.', (CURDATE() - INTERVAL 16 DAY), 'In Case', 1, 'Civil', NULL, 0, 'civil', 1, 1, NULL),
  (12, (CURDATE() - INTERVAL 8 DAY), '18:30:00', 1, 'Noise from welding shop', 'Danilo Ocampo Castillo', 'Welding work continues late into the evening beside a residence.', (CURDATE() - INTERVAL 6 DAY), 'Pending', 9, 'Others', NULL, 0, NULL, 1, 1, NULL),
  (13, (CURDATE() - INTERVAL 6 DAY), '18:30:00', 3, 'Parking blocking driveway', 'Corazon Valdez Torres', 'A tricycle is regularly parked across the complainant''s driveway.', (CURDATE() - INTERVAL 4 DAY), 'Pending', 8, 'Others', NULL, 0, NULL, 1, 1, NULL),
  (14, (CURDATE() - INTERVAL 14 DAY), '18:30:00', 5, 'Lost wallet report', 'Unknown', 'Complainant reports a misplaced wallet for record purposes only.', (CURDATE() - INTERVAL 12 DAY), 'Blotter', NULL, 'Blotter', NULL, 0, 'blotter', 1, 1, NULL),
  (15, (CURDATE() - INTERVAL 16 DAY), '18:30:00', 2, 'Complaint outside barangay jurisdiction', 'Hernan Dimaculangan Lim', 'Parties live in different municipalities, so the complaint was not accepted.', (CURDATE() - INTERVAL 14 DAY), 'Rejected', NULL, 'Others', NULL, 0, NULL, 1, 1, NULL),
  (16, (CURDATE() - INTERVAL 20 DAY), '18:30:00', 6, 'Withdrawn dispute over laundry water', 'Andres Salazar Navarro', 'Complainant withdrew the complaint after both sides talked.', (CURDATE() - INTERVAL 18 DAY), 'Dismissed', 4, 'Civil', NULL, 0, 'civil', 1, 1, 'Withdrawn by the complainant.'),
  (17, (CURDATE() - INTERVAL 11 DAY), '18:30:00', 7, 'Community clean-up disagreement', 'Unknown', 'Filed for record purposes after a disagreement during clean-up.', (CURDATE() - INTERVAL 9 DAY), 'Record Purposes', NULL, 'Others', NULL, 0, NULL, 1, 1, NULL),
  (18, (CURDATE() - INTERVAL 4 DAY), '18:30:00', NULL, 'Unsettled catering balance', 'Marites Domingo Garcia', 'External complainant is asking for the remaining balance of a catering job.', (CURDATE() - INTERVAL 2 DAY), 'Pending', 6, 'Civil', 2, 0, NULL, 1, 1, NULL);

INSERT INTO `complaint_respondents` (`id`, `complaint_id`, `respondent_id`, `respondent_agree`) VALUES
  (1, 1, 2, 1),
  (2, 2, 4, 1),
  (3, 3, 6, 1),
  (4, 4, 8, 1),
  (5, 5, 10, 1),
  (6, 6, 3, 1),
  (7, 7, 5, 1),
  (8, 8, 7, 1),
  (9, 9, 9, 1),
  (10, 10, 1, 1),
  (11, 11, 1, 1),
  (12, 12, 9, 1),
  (13, 13, 8, 1),
  (14, 16, 4, 1),
  (15, 18, 6, 1);

INSERT INTO `case_info` (`Case_ID`, `case_original_id`, `Complaint_ID`, `Case_Status`, `Date_Opened`, `Date_Closed`, `Next_Hearing_Date`, `lupon_assign`, `Case_Deadline`, `Deadline_Overdue`, `case_number`, `Dismiss_Reason`) VALUES
  (1, '001-DEMO', 1, 'Mediation', TIMESTAMP(CURDATE() + INTERVAL -58 DAY, '09:00:00'), NULL, (CURDATE() + INTERVAL 4 DAY), 'Teresita Liwanag Ramos', (CURDATE() - INTERVAL 13 DAY), 0, 1, NULL),
  (2, '002-DEMO', 2, 'Conciliation', TIMESTAMP(CURDATE() + INTERVAL -50 DAY, '09:00:00'), NULL, (CURDATE() + INTERVAL 5 DAY), 'Crisanto Mabini Flores', (CURDATE() - INTERVAL 5 DAY), 0, 2, NULL),
  (3, '003-DEMO', 3, 'Arbitration', TIMESTAMP(CURDATE() + INTERVAL -44 DAY, '09:00:00'), NULL, (CURDATE() + INTERVAL 6 DAY), 'Teresita Liwanag Ramos', (CURDATE() + INTERVAL 1 DAY), 0, 3, NULL),
  (4, '004-DEMO', 4, 'Resolution', TIMESTAMP(CURDATE() + INTERVAL -40 DAY, '09:00:00'), NULL, (CURDATE() + INTERVAL 7 DAY), 'Crisanto Mabini Flores', (CURDATE() + INTERVAL 5 DAY), 0, 4, NULL),
  (5, '005-DEMO', 5, 'Settlement', TIMESTAMP(CURDATE() + INTERVAL -36 DAY, '09:00:00'), NULL, (CURDATE() + INTERVAL 8 DAY), 'Teresita Liwanag Ramos', (CURDATE() + INTERVAL 9 DAY), 0, 5, NULL),
  (6, '006-DEMO', 6, 'Resolved', TIMESTAMP(CURDATE() + INTERVAL -32 DAY, '09:00:00'), TIMESTAMP(CURDATE() + INTERVAL -12 DAY, '16:00:00'), NULL, 'Crisanto Mabini Flores', (CURDATE() + INTERVAL 13 DAY), 0, 6, NULL),
  (7, '007-DEMO', 7, 'Dismissed', TIMESTAMP(CURDATE() + INTERVAL -28 DAY, '09:00:00'), TIMESTAMP(CURDATE() + INTERVAL -8 DAY, '16:00:00'), NULL, 'Teresita Liwanag Ramos', (CURDATE() + INTERVAL 17 DAY), 0, 7, 'Both parties withdrew the case.'),
  (8, '008-DEMO', 8, 'Endorsement for Conciliation', TIMESTAMP(CURDATE() + INTERVAL -24 DAY, '09:00:00'), NULL, (CURDATE() + INTERVAL 11 DAY), 'Crisanto Mabini Flores', (CURDATE() + INTERVAL 21 DAY), 0, 8, NULL),
  (9, '009-DEMO', 9, 'Endorsement for Arbitration', TIMESTAMP(CURDATE() + INTERVAL -20 DAY, '09:00:00'), NULL, (CURDATE() + INTERVAL 12 DAY), 'Teresita Liwanag Ramos', (CURDATE() + INTERVAL 25 DAY), 0, 9, NULL),
  (10, '010-DEMO', 10, 'Mediation', TIMESTAMP(CURDATE() + INTERVAL -16 DAY, '09:00:00'), NULL, (CURDATE() + INTERVAL 13 DAY), 'Crisanto Mabini Flores', (CURDATE() + INTERVAL 29 DAY), 0, 10, NULL),
  (11, '011-DEMO', 11, 'Pending', TIMESTAMP(CURDATE() + INTERVAL -12 DAY, '09:00:00'), NULL, (CURDATE() + INTERVAL 14 DAY), 'Teresita Liwanag Ramos', (CURDATE() + INTERVAL 33 DAY), 0, 11, NULL);

INSERT INTO `case_participants` (`Participant_ID`, `Case_ID`, `Resident_ID`, `Participant_Role`) VALUES
  (1, 1, 1, 'Complainant'),
  (2, 1, 2, 'Respondent'),
  (3, 2, 3, 'Complainant'),
  (4, 2, 4, 'Respondent'),
  (5, 3, 5, 'Complainant'),
  (6, 3, 6, 'Respondent'),
  (7, 4, 7, 'Complainant'),
  (8, 4, 8, 'Respondent'),
  (9, 5, 9, 'Complainant'),
  (10, 5, 10, 'Respondent'),
  (11, 6, 2, 'Complainant'),
  (12, 6, 3, 'Respondent'),
  (13, 7, 4, 'Complainant'),
  (14, 7, 5, 'Respondent'),
  (15, 8, 6, 'Complainant'),
  (16, 8, 7, 'Respondent'),
  (17, 9, 8, 'Complainant'),
  (18, 9, 9, 'Respondent'),
  (19, 10, 1, 'Respondent'),
  (20, 11, 10, 'Complainant'),
  (21, 11, 1, 'Respondent');

INSERT INTO `case_process` (`Process_ID`, `Case_ID`, `Process_Details`, `Date_Processed`) VALUES
  (1, 1, 'Case opened and parties were notified.', (CURDATE() - INTERVAL 58 DAY)),
  (2, 2, 'Case opened and parties were notified.', (CURDATE() - INTERVAL 50 DAY)),
  (3, 3, 'Case opened and parties were notified.', (CURDATE() - INTERVAL 44 DAY)),
  (4, 4, 'Case opened and parties were notified.', (CURDATE() - INTERVAL 40 DAY)),
  (5, 5, 'Case opened and parties were notified.', (CURDATE() - INTERVAL 36 DAY)),
  (6, 6, 'Case opened and parties were notified.', (CURDATE() - INTERVAL 32 DAY)),
  (7, 7, 'Case opened and parties were notified.', (CURDATE() - INTERVAL 28 DAY)),
  (8, 8, 'Case opened and parties were notified.', (CURDATE() - INTERVAL 24 DAY)),
  (9, 9, 'Case opened and parties were notified.', (CURDATE() - INTERVAL 20 DAY)),
  (10, 10, 'Case opened and parties were notified.', (CURDATE() - INTERVAL 16 DAY)),
  (11, 11, 'Case opened and parties were notified.', (CURDATE() - INTERVAL 12 DAY));

INSERT INTO `mediation_info` (`Mediation_ID`, `Case_ID`, `Mediator_Name`, `Mediation_Date`, `Mediation_Result`, `Deadline`) VALUES
  (1, 1, 'Ramon Bayani Cruz', (CURDATE() + INTERVAL 5 DAY), NULL, (CURDATE() + INTERVAL 15 DAY)),
  (2, 10, 'Ramon Bayani Cruz', (CURDATE() + INTERVAL 7 DAY), NULL, (CURDATE() + INTERVAL 17 DAY)),
  (3, 6, 'Ramon Bayani Cruz', (CURDATE() - INTERVAL 30 DAY), 'Both parties reached an agreement.', (CURDATE() - INTERVAL 15 DAY));

INSERT INTO `conciliation` (`Conciliation_ID`, `Case_ID`, `Conciliation_Date`, `Deadline`, `Remarks`, `mediator_name`) VALUES
  (1, 2, (CURDATE() + INTERVAL 6 DAY), (CURDATE() + INTERVAL 21 DAY), 'Pangkat formed for this dispute.', 'Teresita Liwanag Ramos');

INSERT INTO `arbitration` (`Arbitration_ID`, `Case_ID`, `Arbitration_Date`, `Deadline`, `Remarks`, `mediator_name`) VALUES
  (1, 3, (CURDATE() + INTERVAL 8 DAY), (CURDATE() + INTERVAL 18 DAY), 'Parties agreed to arbitration.', 'Ramon Bayani Cruz');

INSERT INTO `resolution` (`Resolution_ID`, `Case_ID`, `Mediator_Name`, `Resolution_Details`, `Resolution_Date`, `Deadline`) VALUES
  (1, 4, 'Ramon Bayani Cruz', 'Respondent agreed to replace the damaged mirror.', (CURDATE() - INTERVAL 5 DAY), (CURDATE() + INTERVAL 10 DAY));

INSERT INTO `settlement` (`Settlement_ID`, `Case_ID`, `Mediator_Name`, `Settlement_Details`, `Date_Agreed`, `Deadline`) VALUES
  (1, 5, 'Ramon Bayani Cruz', 'Medical costs to be shared by both parties.', (CURDATE() - INTERVAL 3 DAY), (CURDATE() + INTERVAL 12 DAY));

INSERT INTO `blotter_info` (`Blotter_ID`, `Case_ID`, `Blotter_Description`, `Reported_By`, `Date_Reported`, `Complaint_ID`) VALUES
  (1, NULL, 'Complainant reported a misplaced wallet near the covered court.', 'Rosario Tolentino Aquino', (CURDATE() - INTERVAL 12 DAY), 14);

INSERT INTO `schedule_list` (`hearingID`, `visible`, `selectedCase`, `hearingTitle`, `hearingDateTime`, `place`, `participant`, `remarks`, `Case_ID`) VALUES
  (1, 1, 1, 'First Mediation Hearing', TIMESTAMP(CURDATE() + INTERVAL 3 DAY, '09:30:00'), 'Barangay Hall Session Room', 'Complainant, Respondent, Lupon Member', 'Please bring valid identification.', 1),
  (2, 1, 2, 'Conciliation Meeting', TIMESTAMP(CURDATE() + INTERVAL 4 DAY, '09:30:00'), 'Barangay Hall Session Room', 'Complainant, Respondent, Lupon Member', 'Please bring valid identification.', 2),
  (3, 1, 3, 'Arbitration Hearing', TIMESTAMP(CURDATE() + INTERVAL 5 DAY, '09:30:00'), 'Barangay Hall Session Room', 'Complainant, Respondent, Lupon Member', 'Please bring valid identification.', 3),
  (4, 1, 4, 'Resolution Follow-up', TIMESTAMP(CURDATE() + INTERVAL 6 DAY, '09:30:00'), 'Barangay Hall Session Room', 'Complainant, Respondent, Lupon Member', 'Please bring valid identification.', 4),
  (5, 1, 5, 'Settlement Signing', TIMESTAMP(CURDATE() + INTERVAL 7 DAY, '09:30:00'), 'Barangay Hall Session Room', 'Complainant, Respondent, Lupon Member', 'Please bring valid identification.', 5),
  (6, 1, 8, 'Endorsement Review', TIMESTAMP(CURDATE() + INTERVAL 8 DAY, '09:30:00'), 'Barangay Hall Session Room', 'Complainant, Respondent, Lupon Member', 'Please bring valid identification.', 8),
  (7, 1, 9, 'Endorsement Review', TIMESTAMP(CURDATE() + INTERVAL 9 DAY, '09:30:00'), 'Barangay Hall Session Room', 'Complainant, Respondent, Lupon Member', 'Please bring valid identification.', 9),
  (8, 1, 10, 'Mediation Hearing', TIMESTAMP(CURDATE() + INTERVAL 10 DAY, '09:30:00'), 'Barangay Hall Session Room', 'Complainant, Respondent, Lupon Member', 'Please bring valid identification.', 10),
  (9, 1, 11, 'Initial Hearing', TIMESTAMP(CURDATE() + INTERVAL 11 DAY, '09:30:00'), 'Barangay Hall Session Room', 'Complainant, Respondent, Lupon Member', 'Please bring valid identification.', 11),
  (10, 1, 6, 'Past Mediation Hearing', TIMESTAMP(CURDATE() + INTERVAL -30 DAY, '10:00:00'), 'Barangay Hall Session Room', 'Complainant, Respondent', 'Completed.', 6);

INSERT INTO `meeting_logs` (`Log_ID`, `Case_ID`, `Hearing_Date`, `Hearing_Time`, `Hearing_Details`, `Hearing_End_Time`, `Complainant_Status`, `Respondent_Status`, `Attendance`, `Reason_Incompliance`) VALUES
  (1, 6, (CURDATE() - INTERVAL 30 DAY), '10:00:00', 'Both parties explained their side and agreed on a payment schedule.', '11:00:00', 'Present', 'Present', 'Complainant, Respondent', NULL),
  (2, 1, (CURDATE() - INTERVAL 20 DAY), '09:30:00', 'Respondent asked for more time to gather documents.', '10:15:00', 'Present', 'Unattended', 'Complainant', 'Respondent had a work conflict.');

INSERT INTO `feedback` (`id`, `official_id`, `official_name`, `message`, `case_id`) VALUES
  (1, 4, 'Teresita Liwanag Ramos', 'Parties were cooperative during the session.', 1),
  (2, 5, 'Crisanto Mabini Flores', 'Recommend one more meeting before endorsement.', 2);

INSERT INTO `notifications` (`notification_id`, `resident_id`, `type`, `title`, `message`, `is_read`, `related_id`, `external_complaint_id`, `official_id`, `isPriority`, `lupon_id`, `is_read_captain`, `is_read_secretary`) VALUES
  (1, 1, 'Hearing', 'Hearing Scheduled', 'Your case (Case ID: 1) has a mediation hearing this week.', 0, 1, NULL, NULL, 0, NULL, 0, 0),
  (2, 1, 'Case', 'Complaint Update', 'Your complaint was accepted and is now a case.', 1, 1, NULL, NULL, 0, NULL, 0, 0),
  (3, NULL, 'Hearing', 'Hearing Scheduled', 'Your case (Case ID: 10) has a mediation hearing soon.', 0, 10, 1, NULL, 0, NULL, 0, 0),
  (4, NULL, 'Complaint', 'New Complaint Filed', 'A new complaint is waiting for review.', 0, 12, NULL, 1, 1, NULL, 0, 0),
  (5, NULL, 'Unverified', 'Resident Awaiting Verification', 'Nestor Bernardo Gonzales registered and needs verification.', 0, 11, NULL, 1, 0, NULL, 0, 0),
  (6, NULL, 'Case', 'Case Assigned', 'Case 1 was assigned to you.', 0, 1, NULL, 4, 0, 4, 0, 0),
  (7, NULL, 'Case', 'Case Needs Assignment', 'Case 11 needs a Lupon member.', 0, 11, NULL, 2, 0, NULL, 0, 0),
  (8, NULL, 'Arbitration', 'Arbitration Started', 'Case 3 has moved to arbitration.', 0, 3, NULL, 3, 1, NULL, 0, 0);

INSERT INTO `site_settings` (`setting_key`, `setting_value`) VALUES
  ('demo_mode_note', 'All records in this database are fictional.');

SET FOREIGN_KEY_CHECKS = 1;
