USE sport_booking;

CREATE TABLE members (
             id VARCHAR(255) PRIMARY KEY,
             password VARCHAR(255) NOT NULL,
             email VARCHAR(255) NOT NULL,
             member_since TIMESTAMP NOT NULL DEFAULT NOW(),
             payment_due DECIMAL(10, 2) );

CREATE TABLE pending_terminations (
             id VARCHAR(255) PRIMARY KEY,
             email VARCHAR(255) NOT NULL,
             request_date TIMESTAMP NOT NULL DEFAULT NOW(),
             payment_due DECIMAL(10, 2) NOT NULL DEFAULT 0 );
             
CREATE TABLE rooms ( 
             id VARCHAR(255) PRIMARY KEY,
             room_type VARCHAR(255) NOT NULL,
             price DECIMAL(10, 2) );
             
CREATE TABLE bookings ( 
             id INT AUTO_INCREMENT,
             room_id VARCHAR(255),
             booked_date DATE NOT NULL,
             booked_time TIME NOT NULL, 
             member_id VARCHAR(255) NOT NULL,
             datetime_of_booking TIMESTAMP NOT NULL DEFAULT NOW(),
             payment_status VARCHAR(255) NOT NULL DEFAULT 'unpaid',
             
             PRIMARY KEY (id, room_id, member_id),
             CONSTRAINT UC1 UNIQUE (room_id, booked_date, booked_time) );
             
ALTER TABLE bookings DROP INDEX UC1;
ALTER TABLE bookings ADD CONSTRAINT UC1 UNIQUE (room_id, booked_date, booked_time);
ALTER TABLE members MODIFY payment_due DECIMAL(10, 2) NOT NULL DEFAULT 0;
ALTER TABLE rooms MODIFY price DECIMAL(10, 2) NOT NULL;
ALTER TABLE bookings 
            ADD CONSTRAINT FK1 FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE ON UPDATE RESTRICT,
            ADD CONSTRAINT FK2 FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE ON UPDATE RESTRICT;

INSERT INTO members (id, password, email, member_since, payment_due) VALUES 
			('cinta', 'cinta1997<3', 'Laura.Cinta@hotmail.com', '2022-04-15 12:10:13', '0.00'),
            ('lilac21', 'lilacmyfav18', 'Bauchi.Lilac21@yahoo.com', '2023-02-06 16:48:43', '0.00'),
            ('aurora', 'dewauror17', 'Dewi_Aurora@yahoo.com', '2022-12-28 05:36:50', '0.00'),
            ('lunar31', 'lunarszg#', 'Belinda_Lunar31@gmail.com', '2022-06-01 21:12:11', '10.00'),
            ('aldebaran19', 'baran2121', 'Leo.Aldebaran19@gmail.com', '2022-05-30 17:30:22', '0.00'),
            ('halley71', 'komhalley15', 'Ophelia_halley71@gmail.com', '2022-09-09 02:30:49', '10.00'),
            ('ares98', 'loveme', 'Nova_Ares98@gmail.com', '2023-01-09 17:36:49', '0.00'),
            ('rhea79', '9715no', 'Rhea_Di79@gmail.com', '2022-12-16 22:59:46', '0.00'),
            ('alan67', '12goback', 'Ceilo_Alan67@yahoo.com', '2022-10-12 05:39:20', '0.00'),
            ('narendra', 'hellome99', 'Jupiter_Narendra99@gmail.com', '2022-07-18 16:28:35', '0.00');
            
INSERT INTO rooms (id, room_type, price) VALUES
            ('AR', 'Archery Range', '120.00'),
            ('B1', 'Badminton Court', '8.00'),
            ('B2', 'Badminton Court', '8.00'),
            ('MPF1', 'Multi Purpose Field', '50.00'),
            ('MPF2', 'Multi Purpose Field', '60.00'),
            ('T1', 'Tennis Court', '10.00'),
            ('T2', 'Tennis Court', '10.00');

INSERT INTO bookings (id, room_id, booked_date, booked_time, member_id, datetime_of_booking, payment_status) VALUES
            ('1', 'Ar', '2022-12-26', '13:00:00', 'alan67', '2022-12-20 20:31:27', 'Paid'),
            ('2', 'MPF1', '2022-12-30', '17:00:00', 'rhea79', '2022-12-22 05:22:10', 'Paid'),
            ('3', 'T2', '2022-12-31', '16:00:00', 'aldebaran19', '2022-12-28 18:14:23', 'Paid'),
            ('4', 'T1', '2023-03-05', '08:00:00', 'lunar31', '2023-02-22 20:19:17', 'Unpaid'),
            ('5', 'MPF2', '2023-03-02', '11:00:00', 'halley71', '2023-03-01 16:13:45', 'Paid'),
            ('6', 'B1', '2023-03-08', '16:00:00', 'halley71', '2023-03-23 22:46:36', 'Paid'),
            ('7', 'B1', '2023-04-15', '14:00:00', 'aldebaran19', '2023-04-12 22:23:20', 'Cancelled'),
            ('8', 'T2', '2023-04-23', '13:00:00', 'aldebaran19', '2023-04-19 10:49:00', 'Cancelled'),
            ('9', 'T1', '2023-05-25', '10:00:00', 'halley71', '2023-05-21 11:20:46', 'Unpaid'),
            ('10', 'B2', '2023-06-12', '15:00:00', 'aurora', '2023-05-30 14:40:23', 'Paid');

SELECT *FROM members;
SELECT *FROM rooms;
SELECT *FROM bookings;

CREATE VIEW member_bookings AS
            SELECT bookings.id, bookings.room_id, rooms.room_type, bookings.booked_date, bookings.booked_time, bookings.member_id, bookings.datetime_of_booking, rooms.price, bookings.payment_status
            FROM
            rooms
            JOIN
            bookings
            ON 
            bookings.room_id = rooms.id;

SELECT *FROM member_bookings ORDER BY bookings.id;

DELIMITER $$
CREATE PROCEDURE insert_new_members (IN p_id VARCHAR(255), IN p_password VARCHAR(255), IN p_email VARCHAR (255))
BEGIN
	 INSERT INTO members (id, password, email) VALUES (p_id, p_password, p_email);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE delete_member (IN p_id VARCHAR(255))
BEGIN
     DELETE FROM members
     WHERE id = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE update_member_password (IN p_id VARCHAR(255), IN p_password VARCHAR(255))
BEGIN
     UPDATE members
     SET password = p_password
     WHERE id = p_id;
END$$
DELIMITER ;   

DELIMITER $$
CREATE PROCEDURE update_member_email (IN p_id VARCHAR(255), IN p_email VARCHAR(255))
BEGIN
     UPDATE members
     SET email = p_email
     WHERE id = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE make_booking (IN p_room_id VARCHAR(255), IN p_booked_date DATE, IN p_booked_time TIME, IN p_member_id VARCHAR(255))
BEGIN
     DECLARE v_price DECIMAL(10, 2);
     DECLARE v_payment_due DECIMAL(10, 2);
     SELECT price INTO v_price FROM rooms WHERE id = p_room_id;
     SELECT payment_due INTO v_payment_due FROM members WHERE id = p_member_id;
     INSERT INTO bookings (room_id, booked_date, booked_time, member_id) VALUES (p_room_id, p_booked_date, p_booked_time, p_member_id);
     UPDATE members SET payment_due = v_payment_due + v_price WHERE id = p_member_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE update_payment (IN p_id INT)
BEGIN
     DECLARE v_member_id VARCHAR(255);
     DECLARE v_payment_due DECIMAL(10, 2);
     DECLARE v_price DECIMAL(10, 2);
     SELECT member_id, price INTO v_member_id, v_price FROM member_bookings WHERE id = p_id;
     SELECT payment_due INTO v_payment_due FROM members WHERE id = v_member_id;
     UPDATE bookings SET payment_status = 'Paid' WHERE id = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE view_bookings (IN p_id INT)
BEGIN
     SELECT *FROM member_bookings WHERE id = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE search_room (IN p_room_type VARCHAR(255), IN p_booked_date DATE, IN p_booked_time TIME)
BEGIN 
     SELECT *FROM rooms WHERE room_type = p_room_type;
     SELECT *FROM bookings WHERE booked_date = p_booked_date;
     SELECT *FROM bookings WHERE booked_time = p_booked_time;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE cancel_booking (IN p_booking_id INT, OUT p_message VARCHAR(255))
BEGIN 
     DECLARE v_cancellation INT;
     DECLARE v_member_id VARCHAR(255);
     DECLARE v_payment_status VARCHAR(255);
     DECLARE v_booked_date DATE;
     DECLARE v_price DECIMAL(10, 2);
     DECLARE v_payment_due DECIMAL(10, 2);
     
     SET v_cancellation = 0;
     
     SELECT member_id, booked_date, price, payment_status INTO v_member_id, v_booked_date, v_price, v_payment_status
     FROM member_bookings WHERE id = p_booking_id;
     
     SELECT payment_due INTO v_payment_due FROM members WHERE id = v_member_id;
     
	 IF CURDATE() >= v_booked_date THEN
         SELECT 'Cancellation cannot be done on/after the booked date' INTO p_message;
	 ELSEIF v_payment_status = 'Cancelled' OR v_payment_status = 'Paid' THEN
         SELECT 'Booking has already been cancelled or paid' INTO p_message;
	 ELSE
	      UPDATE bookings SET payment_status = 'Cancelled' WHERE id = p_booking_id;
          SET v_payment_due = v_payment_due - v_price;
          SET v_cancellation = check_cancellation (p_booking_id);
		  IF v_cancellation >= 2 THEN
		     SET v_payment_due = v_payment_due + 10;
	      END IF;
          UPDATE members SET payment_due = v_payment_due WHERE id = v_member_id;
          SELECT 'Booking Cancelled' INTO p_message;
	 END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER payment_check BEFORE DELETE ON members FOR EACH ROW
BEGIN
     DECLARE v_payment_due DECIMAL(10, 2);
     SELECT payment_due INTO v_payment_due FROM members WHERE id = OLD.id;
     IF v_payment_due > 0 THEN
		INSERT INTO pending_terminations(id, email, payment_due) VALUES(OLD.id, OLD.email, OLD.payment_due);
	 END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION check_cancellation (p_booking_id INT) RETURNS INT DETERMINISTIC 
BEGIN
     DECLARE v_done INT;
     DECLARE v_cancellation INT;
     DECLARE v_current_payment_status VARCHAR(255);
     DECLARE cur CURSOR FOR 
     SELECT payment_status FROM bookings WHERE member_id = (SELECT member_id FROM bookings WHERE id = p_booking_id) 
     ORDER BY datetime_of_booking DESC;
     DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;
     SET v_done = 0;
     SET v_cancellation = 0;
     OPEN cur;
     cancellation_loop: LOOP
           FETCH cur INTO v_current_payment_status;
           IF v_current_payment_status != 'Cancelled' OR v_done = 1 THEN LEAVE cancellation_loop;
               ELSE SET v_cancellation = v_cancellation + 1;
		   END IF;
	 END LOOP;
     CLOSE cur;
     RETURN v_cancellation;
END$$
DELIMITER ;
DROP FUNCTION IF EXISTS check_cancellation;
-- Testing the DATABASE
SELECT * FROM members;
SELECT * FROM pending_terminations;
SELECT * FROM rooms;
SELECT * FROM bookings;

CALL insert_new_members('moon', 'moon89', 'Naero_Moon89');
SELECT * FROM members ORDER BY member_since DESC;

CALL delete_member ('rhea79');
CALL delete_member ('halley71'); ## BEFORE EXECUTE TRIGGERS
CALL delete_member ('lunar31');
CALL delete_member ('aurora');
SELECT * FROM members;
SELECT * FROM pending_terminations;

CALL update_member_password ('cinta', 'futureme12');
CALL update_member_email ('alaN67', 'Ceilo_Alan7');
SELECT * FROM members;

CALL make_booking ('AR', '2024-05-22', '18:00:00', 'cinta');
CALL update_payment ('11');
SELECT * FROM members WHERE id = 'cinta';
SELECT * FROM bookings WHERE member_id = 'cinta';

CALL search_room ('Tennis Court', '2022-12-26', '13:00:00');
CALL search_room ('Badminton Court', '2024-12-26', '14:00:00');

CALL make_booking ('Ar', '2022-12-26', '13:00:00', 'aldebaran19');
CALL make_booking ('Ar', CURDATE() + INTERVAL 2 WEEK, '11:00:00', 'aldebaran19');
SELECT * FROM bookings;

CALL cancel_booking (1, @message);
CALL cancel_booking (17, @message);
SELECT @message;

 -- My little skenario
CALL insert_new_members ('moon', 'moon89', 'Naero_Moon89');
SELECT * FROM members ORDER BY member_since DESC;
CALL search_room ('MPF2', '2024-05-30', '08:00:00'); -- AVAILABLE 
CALL make_booking ('MPF2', '2024-05-30', '08:00:00', 'moon'); -- PAID AS ROOM TYPE
SELECT * FROM bookings; -- ID 18
SELECT * FROM rooms;
CALL update_payment (18); -- PAID
CALL view_bookings (18); -- DONE
CALL cancel_booking (18, @message);
SELECT @message;
SELECT *FROM member_bookings;


