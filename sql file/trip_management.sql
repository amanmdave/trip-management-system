-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 21, 2019 at 02:45 PM
-- Server version: 10.1.38-MariaDB
-- PHP Version: 7.3.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `t6`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `best_hotels` ()  READS SQL DATA
BEGIN 
	DECLARE x int;
	DECLARE it int;
    DECLARE counter int;
    DECLARE rooms VARCHAR(20);
	SET x = 1;
	SELECT COUNT(cust_id) FROM hotel_reservation into it;
	WHILE x <= it DO
    	SET counter = 0;
		SELECT DISTINCT hotel_reservation.room_type,hotel_reservation.cust_id,hotel_reservation.hotel_name,COUNT(hotel_reservation.room_type)*hotel_reservation.number_of_rooms  AS 'Number of rooms booked' FROM hotel_reservation WHERE x = hotel_reservation.cust_id GROUP BY hotel_reservation.cust_id,hotel_reservation.hotel_name,hotel_reservation.room_type;
        SET x = x + 1;
	END WHILE;
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getExpenses` (IN `custid` INT, IN `tripid` INT)  READS SQL DATA
BEGIN
	DECLARE exp INT;
    DECLARE x INT;
    DECLARE it INT;
    DECLARE cost INT;
    DECLARE tempCost INT;
    SET cost = 0;
    
    SELECT COUNT(train_reservation.fare) FROM train_reservation WHERE train_reservation.cust_id = custid AND train_reservation.trip_id = tripid INTO it;
    SET x = 1;
    WHILE x <= it DO
		SELECT train_reservation.fare FROM train_reservation WHERE train_reservation.cust_id = custid AND train_reservation.trip_id = tripid INTO tempCost;
        SELECT tempCost AS 'Train Fare';
        SET cost = cost + tempCost;
        SET x = x+1;
    END WHILE;
    
    SELECT COUNT(flight_reservation.fare) FROM flight_reservation WHERE flight_reservation.cust_id = custid AND flight_reservation.trip_id = tripid INTO it;
    
    SET x = 1;
    WHILE x <= it DO
		SELECT flight_reservation.fare FROM flight_reservation WHERE flight_reservation.cust_id = custid AND flight_reservation.trip_id = tripid INTO tempCost;
        SELECT tempCost AS 'Flight Fare';
        SET cost = cost + tempCost;
        SET x = x+1;
    END WHILE;
    
    SELECT COUNT(bus_reservation.fare) FROM bus_reservation WHERE bus_reservation.cust_id = custid AND bus_reservation.trip_id = tripid INTO it;
    
    SET x = 1;
    WHILE x <= it DO
		SELECT bus_reservation.fare FROM bus_reservation WHERE bus_reservation.cust_id = custid AND bus_reservation.trip_id = tripid INTO tempCost;
        SELECT tempCost AS 'Bus Fare';
        SET cost = cost + tempCost;
        SET x = x+1;
    END WHILE;
    
    SELECT COUNT(cab_reservation.cab_fare) FROM cab_reservation WHERE cab_reservation.cust_id = custid AND cab_reservation.trip_id = tripid INTO it;
    
    SET x = 1;
    WHILE x <= it DO
		SELECT cab_reservation.cab_fare FROM cab_reservation WHERE cab_reservation.cust_id = custid AND cab_reservation.trip_id = tripid INTO tempCost;
        SELECT tempCost AS 'Cab Fare';
        SET cost = cost + tempCost;
        SET x = x+1;
    END WHILE;
   

	SELECT COUNT(hotel_reservation.cost) FROM hotel_reservation WHERE hotel_reservation.cust_id = custid AND hotel_reservation.trip_id = tripid INTO it;
    
    SET x = 1;
    WHILE x <= it DO
		SELECT DISTINCT hotel_reservation.cost FROM hotel_reservation WHERE hotel_reservation.cust_id = custid AND hotel_reservation.trip_id = tripid INTO tempCost;
        SELECT tempCost AS 'Hotel Expense';
        SET cost = cost + tempCost;
        SET x = x+1;
    END WHILE;
    
     SELECT cost AS 'Total Expense';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getNearbyRoutes` (IN `startCity` VARCHAR(20))  READS SQL DATA
BEGIN
	DECLARE x INT;
    DECLARE it INT;
    DECLARE c_name VARCHAR(20);
    DECLARE finished INTEGER DEFAULT 0;
    DECLARE c_cities CURSOR FOR SELECT nearby_city.near_city_name FROM nearby_city WHERE nearby_city.city_name = startCity;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
    OPEN c_cities; 
    get_cities : LOOP
        FETCH c_cities INTO c_name;
        SELECT train.train_id AS 'Train Id',train.train_name AS 'Train Name',train.destination AS 'Nearby City' FROM train WHERE train.source = startCity AND train.destination = c_name;
        IF finished = 1 THEN
        	LEAVE get_cities;
        END IF;
    END LOOP get_cities;
    CLOSE c_cities;
    
    OPEN c_cities;
    get_cities1 : LOOP
    	FETCH c_cities INTO c_name;
        SELECT flight.flight_id AS 'Flight Id',flight.flight_model AS 'Flight Name',flight.destination AS 'Nearby City' FROM flight WHERE flight.source = startCity AND flight.destination = c_name;
		IF finished = 1 THEN
        	LEAVE get_cities1;
        END IF;
    END LOOP get_cities1;
    CLOSE c_cities;
    
    OPEN c_cities;    
    get_cities3 : LOOP
    	FETCH c_cities INTO c_name;
        SELECT bus.bus_id AS 'Bus Id',bus.bus_name AS 'Bus Name',bus.destination AS 'Nearby City' FROM bus WHERE bus.source = startCity AND bus.destination = c_name;
		IF finished = 1 THEN
        	LEAVE get_cities3;
        END IF;
    END LOOP get_cities3;
    CLOSE c_cities;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_spots` (IN `area_given` VARCHAR(20))  READS SQL DATA
BEGIN
    DECLARE x int;
    DECLARE it int;
    SET x = 1;
    SELECT COUNT(hotel.hotel_name) FROM hotel WHERE hotel.area_name = area_given into it;
    WHILE x <= it DO
    	SELECT hotel.hotel_name AS 'Hotels in the area' FROM hotel WHERE hotel.area_name = area_given;
        SET x = x+1;
    END WHILE;
    
	SET x = 1;
    SELECT COUNT(restaurant.rest_name) FROM restaurant WHERE restaurant.area_name = area_given into it;
    WHILE x <= it DO
    	SELECT restaurant.rest_name AS 'Restaurants in the area' FROM restaurant WHERE restaurant.area_name = area_given;
        SET x = x+1;
    END WHILE;
    
    SET x = 1;
    SELECT COUNT(tourist_spots.place_name) FROM tourist_spots WHERE tourist_spots.area_name = area_given into it;
    WHILE x <= it DO
    	SELECT tourist_spots.place_name AS 'Tourist spots in the area' FROM tourist_spots WHERE tourist_spots.area_name = area_given;
        SET x = x+1;
    END WHILE;
    
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_admin1` ()  BEGIN
select * from customer;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_admin2` (IN `cust_i` INT(5))  BEGIN
select * from customer where (customer.cust_id = cust_i);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_admin3` (IN `cust_i` INT(5), IN `trip_i` INT(5))  BEGIN
select DISTINCT * from customer, trip where (customer.cust_id = cust_i) AND trip.trip_id = trip_i AND customer.cust_id = trip.cust_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_admin4` ()  BEGIN
select DISTINCT * from trip, trip_history where trip_history.end_date > CURRENT_DATE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_admin5` (IN `start_dat` DATE, IN `end_dat` DATE)  BEGIN
select DISTINCT * from trip, trip_history where trip_history.end_date >= end_dat AND trip_history.start_date <= start_dat;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_admin6` (IN `tab` TEXT)  BEGIN
SET @s = CONCAT('select * from ', tab);
PREPARE stmt1 FROM @s; 
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_hotel` (IN `AREA` VARCHAR(20))  BEGIN
    SELECT DISTINCT
        *
    FROM
        hotel
    WHERE
        hotel.area_name = AREA
        order by hotel.hotel_name ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_hotel_stars` (IN `stars` INT(1))  BEGIN
    SELECT DISTINCT
        *
    FROM
        hotel
    WHERE
        hotel.stars >= stars
        order by hotel.stars DESC;
       
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_near_cities` (IN `cityn` VARCHAR(20))  BEGIN
    SELECT DISTINCT
        nearby_city.near_city_name
    FROM
        nearby_city
    WHERE
        nearby_city.city_name = cityn
        ORDER BY nearby_city.near_city_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_places` (IN `AREA` VARCHAR(20))  BEGIN
    SELECT DISTINCT
        *
    FROM
        tourist_spots
    WHERE
        tourist_spots.area_name LIKE AREA
        ORDER BY tourist_spots.place_name ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_places_type` (IN `AREA` VARCHAR(20), IN `TYPE` VARCHAR(20))  BEGIN
    SELECT DISTINCT
        *
    FROM
        tourist_spots
    WHERE
        tourist_spots.area_name = AREA AND tourist_spots.place_type = TYPE 
        order by tourist_spots.place_name ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_view` (IN `trip_i` INT(5))  BEGIN
    SELECT DISTINCT
        trip.trip_id,
        customer.cust_id,
        trip.trip_start,
        trip.trip_end,
        people_traveling,
        budget,
        reservation.start_date,
        reservation.end_date
    FROM
        customer,
        trip,
        reservation,
	hotel_reservation,
	bus_reservation,
	train_reservation,
	flight_reservation,
	cab_reservation
    WHERE
        trip_i = trip.trip_id AND customer.cust_id = trip.cust_id AND ((
            trip_i = hotel_reservation.trip_id AND reservation.cust_id = hotel_reservation.cust_id
        ) OR(
            trip_i = bus_reservation.trip_id AND reservation.cust_id= bus_reservation.cust_id
        ) OR(
            trip_i = train_reservation.trip_id AND reservation.cust_id= train_reservation.cust_id
        ) OR(
            trip_i = flight_reservation.trip_id AND reservation.cust_id= flight_reservation.cust_id
        ) OR(
            trip_i = cab_reservation.trip_id AND reservation.cust_id= cab_reservation.cust_id
        ) );
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `func_calccost` (`misc` INT(11) UNSIGNED, `trip_i` INT(5) UNSIGNED) RETURNS INT(11) READS SQL DATA
BEGIN
    DECLARE cost INT(11);
    DECLARE stm varchar(128);
    set cost=0,@x=0,@y=0,@z=0,@w=0,@a=0,@b=0,@c=0,@t=0,@p=0;
    
    SELECT DISTINCT hotel_reservation.cost from hotel_reservation,login WHERE hotel_reservation.cust_id = trip_i AND login.cust_id = hotel_reservation.cust_id and login.status = 1 IS NOT NULL into @x ;
    
    SELECT DISTINCT hotel_reservation.number_of_rooms from hotel_reservation,login WHERE hotel_reservation.cust_id = trip_i AND login.cust_id = hotel_reservation.cust_id and login.status = 1 IS NOT NULL into @y ;
    
    SELECT DISTINCT bus_reservation.fare from bus_reservation,login WHERE bus_reservation.trip_id = trip_i AND login.cust_id = bus_reservation.cust_id and login.status = 1 IS NOT NULL into @z ;
    SELECT DISTINCT bus_reservation.number_of_seats from bus_reservation,login WHERE bus_reservation.trip_id = trip_i AND login.cust_id = bus_reservation.cust_id and login.status = 1 IS NOT NULL into @w ;
    
   SELECT DISTINCT train_reservation.fare from train_reservation,login WHERE ((train_reservation.trip_id = trip_i) or (login.cust_id = train_reservation.cust_id) or (login.status = 1)) IS NOT NULL into @a ;
    
    SELECT DISTINCT train_reservation.tot_seats from train_reservation,login WHERE ((train_reservation.trip_id = trip_i) or (login.cust_id = train_reservation.cust_id) or (login.status = 1)) IS NOT NULL into @b ;
    
    SELECT DISTINCT flight_reservation.fare from flight_reservation,login WHERE flight_reservation.trip_id = trip_i AND login.cust_id = flight_reservation.cust_id and login.status = 1 IS NOT NULL into @c ;
    
   
    SELECT DISTINCT trip.people_traveling from trip,login WHERE trip.trip_id = trip_i AND login.cust_id = trip.cust_id and login.status = 1 IS NOT NULL into @p ;
    
    
        set cost = @x * @y + @z*@w + @a*@b + @c  + misc;
        RETURN cost;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `func_days` (`start_date` DATE, `end_date` DATE) RETURNS INT(11) UNSIGNED BEGIN
   
    return DATEDIFF(end_date, start_date);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `func_hotelcost` (`misc` INT(11) UNSIGNED, `trip_i` INT(5)) RETURNS INT(11) UNSIGNED BEGIN
    DECLARE
        cost INT(11);
    set cost=0,@x=0,@y=0;
    SELECT hotel_reservation.cost from hotel_reservation,login WHERE hotel_reservation.cust_id = trip_i AND login.cust_id = hotel_reservation.cust_id and login.status = 1 IS NOT NULL into @x ;
    SELECT hotel_reservation.number_of_rooms from hotel_reservation,login WHERE hotel_reservation.cust_id = trip_i AND login.cust_id = hotel_reservation.cust_id and login.status = 1 IS NOT NULL into @y ;
    set cost=@x*@y + misc;
    RETURN cost ;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `func_transportcost` (`misc` INT UNSIGNED, `trip_i` INT(5)) RETURNS INT(11) UNSIGNED READS SQL DATA
BEGIN
    DECLARE cost INT(11);
    DECLARE a int(11);
    DECLARE b int(11);
        set cost=0,a=0,b=0,@z=0,@w=0,@c=0;
     SELECT DISTINCT bus_reservation.fare from bus_reservation,login WHERE bus_reservation.trip_id = trip_i AND login.cust_id = bus_reservation.cust_id and login.status = 1 IS NOT NULL into @z ;
    SELECT DISTINCT bus_reservation.number_of_seats from bus_reservation, login WHERE bus_reservation.trip_id = trip_i AND login.cust_id = bus_reservation.cust_id and login.status = 1 IS NOT NULL into @w ;
   
    SELECT DISTINCT flight_reservation.fare from flight_reservation, login WHERE flight_reservation.trip_id = trip_i AND login.cust_id = flight_reservation.cust_id and login.status = 1 IS NOT NULL into @c ;
   SELECT DISTINCT train_reservation.fare from train_reservation, login WHERE ((train_reservation.trip_id = trip_i) or (login.cust_id = train_reservation.cust_id) or (login.status = 1)) IS NOT NULL into a ;
    
    SELECT DISTINCT train_reservation.tot_seats from train_reservation, login WHERE ((train_reservation.trip_id = trip_i) or (login.cust_id = train_reservation.cust_id) or (login.status = 1)) IS NOT NULL into b ;
    
    set cost = a*b + @c + @w*@z + misc;
        RETURN cost ;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `area`
--

CREATE TABLE `area` (
  `area_name` varchar(20) NOT NULL,
  `city_name` varchar(20) NOT NULL,
  `pincode` int(6) NOT NULL,
  `dist_from_station` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `area`
--

INSERT INTO `area` (`area_name`, `city_name`, `pincode`, `dist_from_station`) VALUES
('Athwa Lines', 'Surat', 370041, 12),
('Ghatlodia', 'Ahmedabad', 380050, 13),
('Hajira', 'Surat', 390012, 5),
('Kalupur', 'Ahmedabad', 380029, 1),
('Memnagar', 'Ahmedabad', 380052, 15),
('Naranpura', 'Ahmedabad', 380013, 14);

--
-- Triggers `area`
--
DELIMITER $$
CREATE TRIGGER `trig_dist` BEFORE INSERT ON `area` FOR EACH ROW BEGIN
DECLARE msg varchar(128);
if(new.dist_from_station<0) THEN
set msg = 'Error: Stdno cant be negative....' ;
signal sqlstate '45001' set message_text = msg; 
end if;
if new.pincode<6 THEN
	set msg = 'Error: Stdno cant be negative....';
        signal sqlstate '45001' set message_text = msg;
end if;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bus`
--

CREATE TABLE `bus` (
  `bus_id` int(5) NOT NULL,
  `bus_name` varchar(10) NOT NULL,
  `source` varchar(20) NOT NULL,
  `destination` varchar(20) NOT NULL,
  `totStops` int(11) NOT NULL,
  `plate_number` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `bus`
--

INSERT INTO `bus` (`bus_id`, `bus_name`, `source`, `destination`, `totStops`, `plate_number`) VALUES
(1001, 'Volvo', 'Ahmedabad', 'Surat', 5, 'GJ01SS8932'),
(1002, 'ST', 'Ahmedabad', 'Rajkot', 3, 'GJ01ST4212'),
(1003, 'Volvo', 'Surat', 'Ahmedabad', 4, 'GJ05MM2941'),
(1005, 'busname', 'source', 'desti', 10, 'GJ01-XX'),
(1006, 'busname', 'source', 'desti', 10, 'GJ01-XX1');

--
-- Triggers `bus`
--
DELIMITER $$
CREATE TRIGGER `trig_dest` BEFORE INSERT ON `bus` FOR EACH ROW BEGIN
DECLARE msg varchar(128);
if(new.destination = new.source) THEN
set msg = 'Error: source cannot be same as destination....'; 
signal sqlstate '45001' set message_text = msg; 
end if;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bus_reservation`
--

CREATE TABLE `bus_reservation` (
  `trip_id` int(5) NOT NULL,
  `cust_id` int(5) NOT NULL,
  `bus_id` int(5) NOT NULL,
  `seat_type` varchar(10) NOT NULL,
  `fare` int(11) NOT NULL,
  `seat_no` int(11) NOT NULL,
  `bus_status` text NOT NULL,
  `number_of_seats` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `bus_reservation`
--

INSERT INTO `bus_reservation` (`trip_id`, `cust_id`, `bus_id`, `seat_type`, `fare`, `seat_no`, `bus_status`, `number_of_seats`) VALUES
(3, 4, 1001, 'Chair', 400, 23, 'On Time', 30);

--
-- Triggers `bus_reservation`
--
DELIMITER $$
CREATE TRIGGER `trig_neg` BEFORE INSERT ON `bus_reservation` FOR EACH ROW BEGIN
DECLARE msg varchar(128);
if(new.number_of_seats OR new.fare OR new.seat_no <0) THEN
set msg = 'Error: figures cant be negative....'; 
signal sqlstate '45001' set message_text = msg; 
end if;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bus_specs`
--

CREATE TABLE `bus_specs` (
  `bus_id` int(5) NOT NULL,
  `totSeats` int(11) NOT NULL,
  `acIncluded` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `bus_specs`
--

INSERT INTO `bus_specs` (`bus_id`, `totSeats`, `acIncluded`) VALUES
(1001, 30, 1),
(1002, 40, 0),
(1003, 25, 1);

--
-- Triggers `bus_specs`
--
DELIMITER $$
CREATE TRIGGER `trig_neg_seats` BEFORE INSERT ON `bus_specs` FOR EACH ROW BEGIN 
DECLARE msg varchar(128); 
if new.totSeats<0 THEN 
set msg = 'Error: seats cant be negative....'; signal sqlstate '45001' set message_text = msg; 
end if; 
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cab`
--

CREATE TABLE `cab` (
  `cab_id` int(5) NOT NULL,
  `cab_type` varchar(10) NOT NULL,
  `provider_id` int(5) NOT NULL,
  `cabbie_id` int(5) NOT NULL,
  `plate_number` varchar(10) NOT NULL,
  `cab_city` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cab`
--

INSERT INTO `cab` (`cab_id`, `cab_type`, `provider_id`, `cabbie_id`, `plate_number`, `cab_city`) VALUES
(1, 'Sedan', 1, 1, 'GJ01SS8932', 'Ahmedabad'),
(3, 'SUV', 3, 3, 'GJ13343', 'Rajkot');

-- --------------------------------------------------------

--
-- Table structure for table `cabbie_specs`
--

CREATE TABLE `cabbie_specs` (
  `cabbie_id` int(5) NOT NULL,
  `cabbie_name` text NOT NULL,
  `contact` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cabbie_specs`
--

INSERT INTO `cabbie_specs` (`cabbie_id`, `cabbie_name`, `contact`) VALUES
(1, 'Douglas James', 1204353481),
(3, 'James Earl', 1425395042);

-- --------------------------------------------------------

--
-- Table structure for table `cab_provider`
--

CREATE TABLE `cab_provider` (
  `provider_name` text NOT NULL,
  `provider_id` int(5) NOT NULL,
  `contact` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cab_provider`
--

INSERT INTO `cab_provider` (`provider_name`, `provider_id`, `contact`) VALUES
('Cab Central', 1, 902344231),
('Cabs Inc.', 2, 937854551),
('Southpaw Inc.', 3, 431950235);

-- --------------------------------------------------------

--
-- Table structure for table `cab_reservation`
--

CREATE TABLE `cab_reservation` (
  `trip_id` int(5) NOT NULL,
  `cab_provider_id` int(5) NOT NULL,
  `pickup_date` date NOT NULL,
  `pickup_time` varchar(5) NOT NULL,
  `pickup_location` text NOT NULL,
  `drop_location` text NOT NULL,
  `cab_fare` int(11) NOT NULL,
  `number_of_cabs` int(1) NOT NULL,
  `cust_id` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cab_reservation`
--

INSERT INTO `cab_reservation` (`trip_id`, `cab_provider_id`, `pickup_date`, `pickup_time`, `pickup_location`, `drop_location`, `cab_fare`, `number_of_cabs`, `cust_id`) VALUES
(1, 1, '2019-04-16', '13:00', 'Shanti Palace', 'Riverfront', 80, 1, 1),
(2, 2, '2019-04-16', '13:00', 'Wilhelm Palace', 'Temple', 40, 2, 2);

--
-- Triggers `cab_reservation`
--
DELIMITER $$
CREATE TRIGGER `trig_location` BEFORE INSERT ON `cab_reservation` FOR EACH ROW BEGIN
DECLARE msg varchar(128);
if(new.drop_location = new.pickup_location) THEN
set msg = 'Error: pickup cannot be same as destination....'; 
signal sqlstate '45001' set message_text = msg; 
end if;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cab_specs`
--

CREATE TABLE `cab_specs` (
  `cab_type` varchar(10) NOT NULL,
  `cost_perkm` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cab_specs`
--

INSERT INTO `cab_specs` (`cab_type`, `cost_perkm`) VALUES
('Hatchback', 11),
('Sedan', 13),
('SUV', 15);

-- --------------------------------------------------------

--
-- Table structure for table `city`
--

CREATE TABLE `city` (
  `city_name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `city`
--

INSERT INTO `city` (`city_name`) VALUES
('Ahmedabad'),
('Rajkot'),
('Surat'),
('Vadodra');

-- --------------------------------------------------------

--
-- Table structure for table `coach`
--

CREATE TABLE `coach` (
  `coach_type` varchar(10) NOT NULL,
  `fare` int(11) NOT NULL,
  `totSeats` int(11) NOT NULL,
  `acIncluded` tinyint(1) NOT NULL,
  `coach_range` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `coach`
--

INSERT INTO `coach` (`coach_type`, `fare`, `totSeats`, `acIncluded`, `coach_range`) VALUES
('Chair Car', 400, 45, 1, 'CC'),
('General', 50, 50, 0, 'G'),
('Sleeper', 600, 30, 1, 'S');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `cust_id` int(5) NOT NULL,
  `cust_fname` varchar(20) NOT NULL,
  `cust_lname` varchar(20) NOT NULL,
  `age` int(2) NOT NULL,
  `street_address` text NOT NULL,
  `home_city` varchar(20) NOT NULL,
  `login_status` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`cust_id`, `cust_fname`, `cust_lname`, `age`, `street_address`, `home_city`, `login_status`) VALUES
(1, 'Neil', 'Armstrong', 43, '82, Horizon Apartments, Naranpura', 'Ahmedabad', 1),
(2, 'Edwin', 'Aldrin', 40, '34, Bay View Apartments, Memnagar', 'Ahmedabad', 0),
(3, 'Joseph', 'Stalin', 34, '123, Viscera Bay, Ghatlodia', 'Ahmedabad', 0),
(4, 'Gator', 'Keys', 23, '12, Sun Burn Apartments, Athwa Lines', 'Surat', 0);

-- --------------------------------------------------------

--
-- Table structure for table `flight`
--

CREATE TABLE `flight` (
  `flight_id` int(5) NOT NULL,
  `source` text NOT NULL,
  `destination` text NOT NULL,
  `flight_model` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `flight`
--

INSERT INTO `flight` (`flight_id`, `source`, `destination`, `flight_model`) VALUES
(3001, 'Ahmedabad', 'Surat', 'Jet Airway'),
(3002, 'Ahmedabad', 'Rajkot', 'SpiceJet'),
(3003, 'Surat', 'Ahmedabad', 'Indigo');

-- --------------------------------------------------------

--
-- Table structure for table `flight_reservation`
--

CREATE TABLE `flight_reservation` (
  `trip_id` int(5) NOT NULL,
  `cust_id` int(5) NOT NULL,
  `flight_id` int(5) NOT NULL,
  `seat_type` varchar(10) NOT NULL,
  `fare` int(11) NOT NULL,
  `seat_no` int(11) NOT NULL,
  `flight_status` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `flight_reservation`
--

INSERT INTO `flight_reservation` (`trip_id`, `cust_id`, `flight_id`, `seat_type`, `fare`, `seat_no`, `flight_status`) VALUES
(2, 2, 3002, 'Chair', 15000, 36, 'On TIme');

-- --------------------------------------------------------

--
-- Table structure for table `flight_specs`
--

CREATE TABLE `flight_specs` (
  `flight_model` varchar(10) NOT NULL,
  `totSeats` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `flight_specs`
--

INSERT INTO `flight_specs` (`flight_model`, `totSeats`) VALUES
('Indigo', 65),
('Jet Airway', 80),
('SpiceJet', 50);

-- --------------------------------------------------------

--
-- Table structure for table `hotel`
--

CREATE TABLE `hotel` (
  `hotel_name` varchar(20) NOT NULL,
  `area_name` varchar(20) NOT NULL,
  `street_name` text NOT NULL,
  `website` text NOT NULL,
  `contact` int(11) NOT NULL,
  `total_rooms` int(11) NOT NULL,
  `stars` int(1) NOT NULL,
  `hotel_type` text NOT NULL,
  `wifi_avail` tinyint(1) NOT NULL,
  `number_of_floors` int(11) NOT NULL,
  `restaurants` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `hotel`
--

INSERT INTO `hotel` (`hotel_name`, `area_name`, `street_name`, `website`, `contact`, `total_rooms`, `stars`, `hotel_type`, `wifi_avail`, `number_of_floors`, `restaurants`) VALUES
('Blitzkrieg', 'Memnagar', 'Earl Street', 'www.blitzkrieg.com', 1213412043, 30, 4, '4star', 1, 3, 0),
('Shanti Palace', 'Naranpura', 'Victor Boulevard', 'www.shantipalace.com', 1234125432, 40, 5, '5star', 1, 3, 1),
('Wilhelm Palace', 'Athwa Lines', 'Legion Square', 'www.wilhelmpalace.com', 1902342324, 20, 3, '3star', 0, 2, 0);

-- --------------------------------------------------------

--
-- Table structure for table `hotel_reservation`
--

CREATE TABLE `hotel_reservation` (
  `trip_id` int(5) NOT NULL,
  `cust_id` int(5) NOT NULL,
  `hotel_name` varchar(20) NOT NULL,
  `area_name` varchar(20) NOT NULL,
  `room_type` varchar(20) NOT NULL,
  `cost` int(11) NOT NULL DEFAULT '5000',
  `reservation_date` date NOT NULL,
  `check_out_date` date NOT NULL,
  `date_available_check` tinyint(1) NOT NULL,
  `number_of_rooms` int(11) NOT NULL DEFAULT '1',
  `room_available_check` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `hotel_reservation`
--

INSERT INTO `hotel_reservation` (`trip_id`, `cust_id`, `hotel_name`, `area_name`, `room_type`, `cost`, `reservation_date`, `check_out_date`, `date_available_check`, `number_of_rooms`, `room_available_check`) VALUES
(3, 3, 'Blitzkrieg', 'Ghatlodia', 'Royal Suite', 50000, '2019-04-15', '2019-04-30', 1, 1, 1),
(1, 1, 'Blitzkrieg', 'Memnagar', 'Suite', 40000, '2019-04-20', '2019-04-23', 1, 1, 1),
(2, 2, 'Shanti Palace', 'Naranpura', 'Royal Suite', 50000, '2019-04-15', '2019-04-18', 1, 1, 1),
(1, 1, 'Wilhelm Palace', 'Athwa Lines', 'Single', 5000, '2019-04-15', '2019-04-20', 1, 2, 1);

--
-- Triggers `hotel_reservation`
--
DELIMITER $$
CREATE TRIGGER `trig_roomcost` BEFORE INSERT ON `hotel_reservation` FOR EACH ROW set new.cost = ( SELECT cost FROM room_specs WHERE (new.room_type = room_specs.room_type))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `cust_id` int(5) NOT NULL,
  `username` varchar(10) NOT NULL,
  `password` varchar(10) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`cust_id`, `username`, `password`, `status`) VALUES
(1, 'neilA', 'neilA', 1),
(2, 'edwinA', 'edwinA', 0),
(3, 'josephS', 'josephS', 0),
(4, 'gatorK', 'gatorK', 0);

-- --------------------------------------------------------

--
-- Table structure for table `nearby_city`
--

CREATE TABLE `nearby_city` (
  `city_name` varchar(20) NOT NULL,
  `near_city_name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `nearby_city`
--

INSERT INTO `nearby_city` (`city_name`, `near_city_name`) VALUES
('Ahmedabad', 'Rajkot'),
('Ahmedabad', 'Surat'),
('Ahmedabad', 'Vadodra'),
('Rajkot', 'Ahmedabad'),
('Surat', 'Ahmedabad'),
('Vadodra', 'Ahmedabad'),
('Vadodra', 'Surat');

-- --------------------------------------------------------

--
-- Table structure for table `reservation`
--

CREATE TABLE `reservation` (
  `cust_id` int(5) NOT NULL,
  `trip_id` int(5) NOT NULL,
  `trip_start` varchar(20) NOT NULL,
  `trip_end` varchar(20) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `mode_of_payment` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `reservation`
--

INSERT INTO `reservation` (`cust_id`, `trip_id`, `trip_start`, `trip_end`, `start_date`, `end_date`, `mode_of_payment`) VALUES
(1, 1, 'Ahmedabad', 'Surat', '2019-04-15', '2019-04-15', 'Cash'),
(2, 2, 'Ahmedabad', 'Rajkot', '2019-04-15', '2019-04-15', 'Cash'),
(3, 3, 'Ahmedabad', 'Vadodra', '2019-04-12', '2019-04-30', 'Gold'),
(4, 4, 'Surat', 'Ahmedabad', '2019-04-15', '2019-04-15', 'Card');

--
-- Triggers `reservation`
--
DELIMITER $$
CREATE TRIGGER `trig_history` AFTER INSERT ON `reservation` FOR EACH ROW BEGIN

       # set @cost = func_calccost(0, new.trip_id);
INSERT INTO trip_history(cust_id, trip_start, trip_end,start_date, end_date, totCost) VALUES(new.cust_id, new.trip_start, new.trip_end, new.start_date, new.end_date, 0);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `restaurant`
--

CREATE TABLE `restaurant` (
  `rest_name` varchar(20) NOT NULL,
  `area_name` varchar(20) NOT NULL,
  `city` varchar(20) NOT NULL,
  `food_type` text NOT NULL,
  `opening_hour` time NOT NULL,
  `closing_hour` time NOT NULL,
  `cost_per_person` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `restaurant`
--

INSERT INTO `restaurant` (`rest_name`, `area_name`, `city`, `food_type`, `opening_hour`, `closing_hour`, `cost_per_person`) VALUES
('Dominos', 'Memnagar', 'Ahmedabad', 'Pizza', '06:00:00', '00:00:00', 140),
('Mc Donalds', 'Naranpura', 'Ahmedabad', 'Fast Food', '08:00:00', '23:00:00', 80),
('Subway', 'Athwa Lines', 'Surat', 'Fast Food', '09:00:00', '22:00:00', 100);

-- --------------------------------------------------------

--
-- Table structure for table `room`
--

CREATE TABLE `room` (
  `room_number` int(3) NOT NULL,
  `room_type` varchar(20) NOT NULL,
  `floor` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `room`
--

INSERT INTO `room` (`room_number`, `room_type`, `floor`) VALUES
(201, 'Deluxe', 2),
(203, 'Royal Suite', 2),
(6, 'Single', 1),
(303, 'Suite', 3);

-- --------------------------------------------------------

--
-- Table structure for table `room_specs`
--

CREATE TABLE `room_specs` (
  `room_type` varchar(20) NOT NULL,
  `cost` int(11) NOT NULL,
  `isDoubleBed` tinyint(1) NOT NULL,
  `isSmoking` tinyint(1) NOT NULL,
  `acIncluded` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `room_specs`
--

INSERT INTO `room_specs` (`room_type`, `cost`, `isDoubleBed`, `isSmoking`, `acIncluded`) VALUES
('Deluxe', 15000, 1, 0, 0),
('Royal Suite', 50000, 1, 1, 1),
('Single', 5000, 0, 0, 1),
('Suite', 40000, 1, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `schedule`
--

CREATE TABLE `schedule` (
  `vehicle_id` int(5) NOT NULL,
  `depart_date` date NOT NULL,
  `arrival_date` date NOT NULL,
  `arrival_time` time NOT NULL,
  `depart_time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `schedule`
--

INSERT INTO `schedule` (`vehicle_id`, `depart_date`, `arrival_date`, `arrival_time`, `depart_time`) VALUES
(1001, '2019-04-15', '2019-04-15', '16:30:00', '12:38:00'),
(2001, '2019-04-15', '2019-04-15', '21:30:00', '15:00:00'),
(2002, '2019-04-15', '2019-04-15', '07:00:00', '12:00:00'),
(3003, '2019-04-15', '2019-04-15', '19:30:00', '20:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `tourist_spots`
--

CREATE TABLE `tourist_spots` (
  `place_name` varchar(20) NOT NULL,
  `area_name` varchar(20) NOT NULL,
  `street_address` text NOT NULL,
  `place_type` text NOT NULL,
  `website` text NOT NULL,
  `opening_hour` time NOT NULL,
  `closing_hour` time NOT NULL,
  `cost_per_person` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tourist_spots`
--

INSERT INTO `tourist_spots` (`place_name`, `area_name`, `street_address`, `place_type`, `website`, `opening_hour`, `closing_hour`, `cost_per_person`) VALUES
('Riverfront', 'Naranpura', 'Riverfront', 'Interest', 'www.riverfront.com', '10:00:00', '22:00:00', 20),
('Sidi Saiyad Jali', 'Kalupur', 'Some Road', 'Historical', 'www.ssj.com', '09:00:00', '19:00:00', 30),
('Temple', 'Hajira', 'Grant Road', 'Religious', 'www.thetemple.com', '05:00:00', '23:00:00', 10);

-- --------------------------------------------------------

--
-- Table structure for table `train`
--

CREATE TABLE `train` (
  `train_id` int(5) NOT NULL,
  `train_name` varchar(10) NOT NULL,
  `source` text NOT NULL,
  `destination` text NOT NULL,
  `totCoaches` int(11) NOT NULL,
  `totStops` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `train`
--

INSERT INTO `train` (`train_id`, `train_name`, `source`, `destination`, `totCoaches`, `totStops`) VALUES
(2001, 'Guj Exp', 'Ahmedabad', 'Mumbai', 18, 5),
(2002, 'Sayaji Exp', 'Ahmedabad', 'Mumbai', 12, 8),
(2003, 'Rajdhani', 'Delhi', 'Mumbai', 20, 9),
(2004, 'Garibrath', 'Ahmedabad', 'Rajkot', 13, 3);

-- --------------------------------------------------------

--
-- Table structure for table `train_reservation`
--

CREATE TABLE `train_reservation` (
  `trip_id` int(5) NOT NULL,
  `cust_id` int(5) NOT NULL,
  `train_id` int(5) NOT NULL,
  `coach_type` varchar(10) NOT NULL,
  `fare` int(11) NOT NULL,
  `seat_no` int(11) NOT NULL,
  `train_status` text NOT NULL,
  `tot_seats` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `train_reservation`
--

INSERT INTO `train_reservation` (`trip_id`, `cust_id`, `train_id`, `coach_type`, `fare`, `seat_no`, `train_status`, `tot_seats`) VALUES
(1, 1, 2001, 'Chair Car', 1200, 3, 'On Time', 3);

-- --------------------------------------------------------

--
-- Table structure for table `trip`
--

CREATE TABLE `trip` (
  `trip_id` int(5) NOT NULL,
  `cust_id` int(5) NOT NULL,
  `trip_start` varchar(20) NOT NULL,
  `trip_end` varchar(20) NOT NULL,
  `people_traveling` int(3) NOT NULL,
  `budget` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `trip`
--

INSERT INTO `trip` (`trip_id`, `cust_id`, `trip_start`, `trip_end`, `people_traveling`, `budget`) VALUES
(1, 1, 'Ahmedabad', 'Surat', 3, 45000),
(2, 2, 'Ahmedabad', 'Rajkot', 2, 100000),
(3, 3, 'Ahmedabad', 'Vadodra', 5, 250000),
(4, 4, 'Surat', 'Ahmedabad', 1, 93000);

-- --------------------------------------------------------

--
-- Table structure for table `trip_history`
--

CREATE TABLE `trip_history` (
  `cust_id` int(11) NOT NULL,
  `trip_start` varchar(20) NOT NULL,
  `trip_end` varchar(20) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `totCost` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `trip_history`
--

INSERT INTO `trip_history` (`cust_id`, `trip_start`, `trip_end`, `start_date`, `end_date`, `totCost`) VALUES
(3, 'Ahmedabad', 'Vadodra', '2019-04-12', '2019-04-30', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `area`
--
ALTER TABLE `area`
  ADD PRIMARY KEY (`area_name`,`city_name`),
  ADD KEY `city_name` (`city_name`);

--
-- Indexes for table `bus`
--
ALTER TABLE `bus`
  ADD PRIMARY KEY (`bus_id`),
  ADD UNIQUE KEY `plate_number` (`plate_number`);

--
-- Indexes for table `bus_reservation`
--
ALTER TABLE `bus_reservation`
  ADD PRIMARY KEY (`cust_id`,`bus_id`,`trip_id`) USING BTREE,
  ADD UNIQUE KEY `seat_no` (`seat_no`),
  ADD KEY `bus_reservation_ibfk_2` (`bus_id`);

--
-- Indexes for table `bus_specs`
--
ALTER TABLE `bus_specs`
  ADD KEY `bus_specs_ibfk_1` (`bus_id`);

--
-- Indexes for table `cab`
--
ALTER TABLE `cab`
  ADD PRIMARY KEY (`cab_id`),
  ADD KEY `cab_ibfk_1` (`cab_type`),
  ADD KEY `cab_ibfk_2` (`provider_id`),
  ADD KEY `cab_ibfk_3` (`cabbie_id`),
  ADD KEY `cab_ibfk_4` (`cab_city`);

--
-- Indexes for table `cabbie_specs`
--
ALTER TABLE `cabbie_specs`
  ADD PRIMARY KEY (`cabbie_id`);

--
-- Indexes for table `cab_provider`
--
ALTER TABLE `cab_provider`
  ADD PRIMARY KEY (`provider_id`);

--
-- Indexes for table `cab_reservation`
--
ALTER TABLE `cab_reservation`
  ADD PRIMARY KEY (`cust_id`);

--
-- Indexes for table `cab_specs`
--
ALTER TABLE `cab_specs`
  ADD PRIMARY KEY (`cab_type`);

--
-- Indexes for table `city`
--
ALTER TABLE `city`
  ADD PRIMARY KEY (`city_name`);

--
-- Indexes for table `coach`
--
ALTER TABLE `coach`
  ADD PRIMARY KEY (`coach_type`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`cust_id`) USING BTREE,
  ADD KEY `customer_ibfk_1` (`home_city`);

--
-- Indexes for table `flight`
--
ALTER TABLE `flight`
  ADD PRIMARY KEY (`flight_id`),
  ADD KEY `flight_ibfk_1` (`flight_model`);

--
-- Indexes for table `flight_reservation`
--
ALTER TABLE `flight_reservation`
  ADD PRIMARY KEY (`cust_id`,`flight_id`),
  ADD UNIQUE KEY `seat_no` (`seat_no`),
  ADD KEY `flight_reservation_ibfk_2` (`flight_id`);

--
-- Indexes for table `flight_specs`
--
ALTER TABLE `flight_specs`
  ADD PRIMARY KEY (`flight_model`);

--
-- Indexes for table `hotel`
--
ALTER TABLE `hotel`
  ADD PRIMARY KEY (`hotel_name`,`area_name`),
  ADD KEY `hotel_ibfk_1` (`area_name`);

--
-- Indexes for table `hotel_reservation`
--
ALTER TABLE `hotel_reservation`
  ADD PRIMARY KEY (`hotel_name`,`area_name`,`trip_id`) USING BTREE,
  ADD KEY `hotel_reservation_ibfk_2` (`area_name`),
  ADD KEY `hotel_reservation_ibfk_3` (`room_type`),
  ADD KEY `hotel_reservation_ibfk_4` (`cust_id`);

--
-- Indexes for table `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`cust_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `nearby_city`
--
ALTER TABLE `nearby_city`
  ADD PRIMARY KEY (`city_name`,`near_city_name`),
  ADD KEY `nearby_city_ibfk_2` (`near_city_name`);

--
-- Indexes for table `reservation`
--
ALTER TABLE `reservation`
  ADD PRIMARY KEY (`cust_id`);

--
-- Indexes for table `restaurant`
--
ALTER TABLE `restaurant`
  ADD PRIMARY KEY (`rest_name`,`area_name`),
  ADD KEY `restaurant_ibfk_1` (`area_name`,`city`);

--
-- Indexes for table `room`
--
ALTER TABLE `room`
  ADD PRIMARY KEY (`room_type`,`room_number`) USING BTREE;

--
-- Indexes for table `room_specs`
--
ALTER TABLE `room_specs`
  ADD PRIMARY KEY (`room_type`);

--
-- Indexes for table `schedule`
--
ALTER TABLE `schedule`
  ADD PRIMARY KEY (`vehicle_id`,`depart_date`,`depart_time`);

--
-- Indexes for table `tourist_spots`
--
ALTER TABLE `tourist_spots`
  ADD PRIMARY KEY (`place_name`,`area_name`),
  ADD KEY `tourist_spot_ibfk_1` (`area_name`);

--
-- Indexes for table `train`
--
ALTER TABLE `train`
  ADD PRIMARY KEY (`train_id`);

--
-- Indexes for table `train_reservation`
--
ALTER TABLE `train_reservation`
  ADD PRIMARY KEY (`cust_id`,`train_id`),
  ADD UNIQUE KEY `seat_no` (`seat_no`),
  ADD KEY `train_reservation_ibfk_2` (`coach_type`),
  ADD KEY `train_reservation_ibfk_3` (`train_id`);

--
-- Indexes for table `trip`
--
ALTER TABLE `trip`
  ADD PRIMARY KEY (`cust_id`,`trip_start`,`trip_end`,`trip_id`) USING BTREE;

--
-- Indexes for table `trip_history`
--
ALTER TABLE `trip_history`
  ADD PRIMARY KEY (`cust_id`),
  ADD KEY `history_ibfk1` (`cust_id`,`trip_start`,`trip_end`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `area`
--
ALTER TABLE `area`
  ADD CONSTRAINT `area_ibfk_1` FOREIGN KEY (`city_name`) REFERENCES `city` (`city_name`);

--
-- Constraints for table `bus_reservation`
--
ALTER TABLE `bus_reservation`
  ADD CONSTRAINT `bus_reservation_ibfk_1` FOREIGN KEY (`cust_id`) REFERENCES `customer` (`cust_id`),
  ADD CONSTRAINT `bus_reservation_ibfk_2` FOREIGN KEY (`bus_id`) REFERENCES `bus` (`bus_id`);

--
-- Constraints for table `bus_specs`
--
ALTER TABLE `bus_specs`
  ADD CONSTRAINT `bus_specs_ibfk_1` FOREIGN KEY (`bus_id`) REFERENCES `bus` (`bus_id`);

--
-- Constraints for table `cab`
--
ALTER TABLE `cab`
  ADD CONSTRAINT `cab_ibfk_1` FOREIGN KEY (`cab_type`) REFERENCES `cab_specs` (`cab_type`),
  ADD CONSTRAINT `cab_ibfk_2` FOREIGN KEY (`provider_id`) REFERENCES `cab_provider` (`provider_id`),
  ADD CONSTRAINT `cab_ibfk_3` FOREIGN KEY (`cabbie_id`) REFERENCES `cabbie_specs` (`cabbie_id`),
  ADD CONSTRAINT `cab_ibfk_4` FOREIGN KEY (`cab_city`) REFERENCES `city` (`city_name`);

--
-- Constraints for table `customer`
--
ALTER TABLE `customer`
  ADD CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`home_city`) REFERENCES `city` (`city_name`);

--
-- Constraints for table `flight`
--
ALTER TABLE `flight`
  ADD CONSTRAINT `flight_ibfk_1` FOREIGN KEY (`flight_model`) REFERENCES `flight_specs` (`flight_model`);

--
-- Constraints for table `flight_reservation`
--
ALTER TABLE `flight_reservation`
  ADD CONSTRAINT `flight_reservation_ibfk_1` FOREIGN KEY (`cust_id`) REFERENCES `customer` (`cust_id`),
  ADD CONSTRAINT `flight_reservation_ibfk_2` FOREIGN KEY (`flight_id`) REFERENCES `flight` (`flight_id`);

--
-- Constraints for table `hotel`
--
ALTER TABLE `hotel`
  ADD CONSTRAINT `hotel_ibfk_1` FOREIGN KEY (`area_name`) REFERENCES `area` (`area_name`);

--
-- Constraints for table `hotel_reservation`
--
ALTER TABLE `hotel_reservation`
  ADD CONSTRAINT `hotel_reservation_ibfk_1` FOREIGN KEY (`hotel_name`) REFERENCES `hotel` (`hotel_name`),
  ADD CONSTRAINT `hotel_reservation_ibfk_2` FOREIGN KEY (`area_name`) REFERENCES `area` (`area_name`),
  ADD CONSTRAINT `hotel_reservation_ibfk_3` FOREIGN KEY (`room_type`) REFERENCES `room` (`room_type`),
  ADD CONSTRAINT `hotel_reservation_ibfk_4` FOREIGN KEY (`cust_id`) REFERENCES `customer` (`cust_id`);

--
-- Constraints for table `login`
--
ALTER TABLE `login`
  ADD CONSTRAINT `login_ibfk1` FOREIGN KEY (`cust_id`) REFERENCES `customer` (`cust_id`);

--
-- Constraints for table `nearby_city`
--
ALTER TABLE `nearby_city`
  ADD CONSTRAINT `nearby_city_ibfk_1` FOREIGN KEY (`city_name`) REFERENCES `city` (`city_name`),
  ADD CONSTRAINT `nearby_city_ibfk_2` FOREIGN KEY (`near_city_name`) REFERENCES `city` (`city_name`);

--
-- Constraints for table `reservation`
--
ALTER TABLE `reservation`
  ADD CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`cust_id`) REFERENCES `customer` (`cust_id`);

--
-- Constraints for table `restaurant`
--
ALTER TABLE `restaurant`
  ADD CONSTRAINT `restaurant_ibfk_1` FOREIGN KEY (`area_name`,`city`) REFERENCES `area` (`area_name`, `city_name`);

--
-- Constraints for table `room`
--
ALTER TABLE `room`
  ADD CONSTRAINT `room_ibfk_1` FOREIGN KEY (`room_type`) REFERENCES `room_specs` (`room_type`);

--
-- Constraints for table `tourist_spots`
--
ALTER TABLE `tourist_spots`
  ADD CONSTRAINT `tourist_spot_ibfk_1` FOREIGN KEY (`area_name`) REFERENCES `area` (`area_name`);

--
-- Constraints for table `train_reservation`
--
ALTER TABLE `train_reservation`
  ADD CONSTRAINT `train_reservation_ibfk_1` FOREIGN KEY (`cust_id`) REFERENCES `customer` (`cust_id`),
  ADD CONSTRAINT `train_reservation_ibfk_2` FOREIGN KEY (`coach_type`) REFERENCES `coach` (`coach_type`),
  ADD CONSTRAINT `train_reservation_ibfk_3` FOREIGN KEY (`train_id`) REFERENCES `train` (`train_id`);

--
-- Constraints for table `trip`
--
ALTER TABLE `trip`
  ADD CONSTRAINT `trip_ibfk_1` FOREIGN KEY (`cust_id`) REFERENCES `customer` (`cust_id`);

--
-- Constraints for table `trip_history`
--
ALTER TABLE `trip_history`
  ADD CONSTRAINT `history_ibfk1` FOREIGN KEY (`cust_id`,`trip_start`,`trip_end`) REFERENCES `trip` (`cust_id`, `trip_start`, `trip_end`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
