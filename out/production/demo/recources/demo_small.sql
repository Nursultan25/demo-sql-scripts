--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.3
-- Dumped by pg_dump version 9.6.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;
--
-- Name: demo; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE demo;

\connect demo

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: bookings; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA bookings;


--
-- Name: SCHEMA bookings; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA bookings IS 'Airlines demo database schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = bookings, pg_catalog;

--
-- Name: lang(); Type: FUNCTION; Schema: bookings; Owner: -
--

CREATE FUNCTION lang() RETURNS text
    LANGUAGE plpgsql STABLE
AS $$
BEGIN
    RETURN current_setting('bookings.lang');
EXCEPTION
    WHEN undefined_object THEN
        RETURN NULL;
END;
$$;


--
-- Name: now(); Type: FUNCTION; Schema: bookings; Owner: -
--

CREATE FUNCTION now() RETURNS timestamp with time zone
    LANGUAGE sql IMMUTABLE
AS $$SELECT '2017-08-15 18:00:00'::TIMESTAMP AT TIME ZONE 'Europe/Moscow';$$;


--
-- Name: FUNCTION now(); Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON FUNCTION now() IS 'Point in time according to which the data are generated';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: aircrafts_data; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE aircrafts_data (
                                aircraft_code character(3) NOT NULL,
                                model jsonb NOT NULL,
                                range integer NOT NULL,
                                CONSTRAINT aircrafts_range_check CHECK ((range > 0))
);


--
-- Name: TABLE aircrafts_data; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE aircrafts_data IS 'Aircrafts (internal data)';


--
-- Name: COLUMN aircrafts_data.aircraft_code; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN aircrafts_data.aircraft_code IS 'Aircraft code, IATA';


--
-- Name: COLUMN aircrafts_data.model; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN aircrafts_data.model IS 'Aircraft model';


--
-- Name: COLUMN aircrafts_data.range; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN aircrafts_data.range IS 'Maximal flying distance, km';


--
-- Name: aircrafts; Type: VIEW; Schema: bookings; Owner: -
--

CREATE VIEW aircrafts AS
SELECT ml.aircraft_code,
       (ml.model ->> lang()) AS model,
       ml.range
FROM aircrafts_data ml;


--
-- Name: VIEW aircrafts; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON VIEW aircrafts IS 'Aircrafts';


--
-- Name: COLUMN aircrafts.aircraft_code; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN aircrafts.aircraft_code IS 'Aircraft code, IATA';


--
-- Name: COLUMN aircrafts.model; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN aircrafts.model IS 'Aircraft model';


--
-- Name: COLUMN aircrafts.range; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN aircrafts.range IS 'Maximal flying distance, km';


--
-- Name: airports_data; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE airports_data (
                               airport_code character(3) NOT NULL,
                               airport_name jsonb NOT NULL,
                               city jsonb NOT NULL,
                               coordinates point NOT NULL,
                               timezone text NOT NULL
);


--
-- Name: TABLE airports_data; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE airports_data IS 'Airports (internal data)';


--
-- Name: COLUMN airports_data.airport_code; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN airports_data.airport_code IS 'Airport code';


--
-- Name: COLUMN airports_data.airport_name; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN airports_data.airport_name IS 'Airport name';


--
-- Name: COLUMN airports_data.city; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN airports_data.city IS 'City';


--
-- Name: COLUMN airports_data.coordinates; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN airports_data.coordinates IS 'Airport coordinates (longitude and latitude)';


--
-- Name: COLUMN airports_data.timezone; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN airports_data.timezone IS 'Airport time zone';


--
-- Name: airports; Type: VIEW; Schema: bookings; Owner: -
--

CREATE VIEW airports AS
SELECT ml.airport_code,
       (ml.airport_name ->> lang()) AS airport_name,
       (ml.city ->> lang()) AS city,
       ml.coordinates,
       ml.timezone
FROM airports_data ml;


--
-- Name: VIEW airports; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON VIEW airports IS 'Airports';


--
-- Name: COLUMN airports.airport_code; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN airports.airport_code IS 'Airport code';


--
-- Name: COLUMN airports.airport_name; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN airports.airport_name IS 'Airport name';


--
-- Name: COLUMN airports.city; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN airports.city IS 'City';


--
-- Name: COLUMN airports.coordinates; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN airports.coordinates IS 'Airport coordinates (longitude and latitude)';


--
-- Name: COLUMN airports.timezone; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN airports.timezone IS 'Airport time zone';


--
-- Name: boarding_passes; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE boarding_passes (
                                 ticket_no character(13) NOT NULL,
                                 flight_id integer NOT NULL,
                                 boarding_no integer NOT NULL,
                                 seat_no character varying(4) NOT NULL
);


--
-- Name: TABLE boarding_passes; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE boarding_passes IS 'Boarding passes';


--
-- Name: COLUMN boarding_passes.ticket_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN boarding_passes.ticket_no IS 'Ticket number';


--
-- Name: COLUMN boarding_passes.flight_id; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN boarding_passes.flight_id IS 'Flight ID';


--
-- Name: COLUMN boarding_passes.boarding_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN boarding_passes.boarding_no IS 'Boarding pass number';


--
-- Name: COLUMN boarding_passes.seat_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN boarding_passes.seat_no IS 'Seat number';


--
-- Name: bookings; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE bookings (
                          book_ref character(6) NOT NULL,
                          book_date timestamp with time zone NOT NULL,
                          total_amount numeric(10,2) NOT NULL
);


--
-- Name: TABLE bookings; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE bookings IS 'Bookings';


--
-- Name: COLUMN bookings.book_ref; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.book_ref IS 'Booking number';


--
-- Name: COLUMN bookings.book_date; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.book_date IS 'Booking date';


--
-- Name: COLUMN bookings.total_amount; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.total_amount IS 'Total booking cost';


--
-- Name: flights; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE flights (
                         flight_id integer NOT NULL,
                         flight_no character(6) NOT NULL,
                         scheduled_departure timestamp with time zone NOT NULL,
                         scheduled_arrival timestamp with time zone NOT NULL,
                         departure_airport character(3) NOT NULL,
                         arrival_airport character(3) NOT NULL,
                         status character varying(20) NOT NULL,
                         aircraft_code character(3) NOT NULL,
                         actual_departure timestamp with time zone,
                         actual_arrival timestamp with time zone,
                         CONSTRAINT flights_check CHECK ((scheduled_arrival > scheduled_departure)),
                         CONSTRAINT flights_check1 CHECK (((actual_arrival IS NULL) OR ((actual_departure IS NOT NULL) AND (actual_arrival IS NOT NULL) AND (actual_arrival > actual_departure)))),
                         CONSTRAINT flights_status_check CHECK (((status)::text = ANY (ARRAY[('On Time'::character varying)::text, ('Delayed'::character varying)::text, ('Departed'::character varying)::text, ('Arrived'::character varying)::text, ('Scheduled'::character varying)::text, ('Cancelled'::character varying)::text])))
);


--
-- Name: TABLE flights; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE flights IS 'Flights';


--
-- Name: COLUMN flights.flight_id; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights.flight_id IS 'Flight ID';


--
-- Name: COLUMN flights.flight_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights.flight_no IS 'Flight number';


--
-- Name: COLUMN flights.scheduled_departure; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights.scheduled_departure IS 'Scheduled departure time';


--
-- Name: COLUMN flights.scheduled_arrival; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights.scheduled_arrival IS 'Scheduled arrival time';


--
-- Name: COLUMN flights.departure_airport; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights.departure_airport IS 'Airport of departure';


--
-- Name: COLUMN flights.arrival_airport; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights.arrival_airport IS 'Airport of arrival';


--
-- Name: COLUMN flights.status; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights.status IS 'Flight status';


--
-- Name: COLUMN flights.aircraft_code; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights.aircraft_code IS 'Aircraft code, IATA';


--
-- Name: COLUMN flights.actual_departure; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights.actual_departure IS 'Actual departure time';


--
-- Name: COLUMN flights.actual_arrival; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights.actual_arrival IS 'Actual arrival time';


--
-- Name: flights_flight_id_seq; Type: SEQUENCE; Schema: bookings; Owner: -
--

CREATE SEQUENCE flights_flight_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: flights_flight_id_seq; Type: SEQUENCE OWNED BY; Schema: bookings; Owner: -
--

ALTER SEQUENCE flights_flight_id_seq OWNED BY flights.flight_id;


--
-- Name: flights_v; Type: VIEW; Schema: bookings; Owner: -
--

CREATE VIEW flights_v AS
SELECT f.flight_id,
       f.flight_no,
       f.scheduled_departure,
       timezone(dep.timezone, f.scheduled_departure) AS scheduled_departure_local,
       f.scheduled_arrival,
       timezone(arr.timezone, f.scheduled_arrival) AS scheduled_arrival_local,
       (f.scheduled_arrival - f.scheduled_departure) AS scheduled_duration,
       f.departure_airport,
       dep.airport_name AS departure_airport_name,
       dep.city AS departure_city,
       f.arrival_airport,
       arr.airport_name AS arrival_airport_name,
       arr.city AS arrival_city,
       f.status,
       f.aircraft_code,
       f.actual_departure,
       timezone(dep.timezone, f.actual_departure) AS actual_departure_local,
       f.actual_arrival,
       timezone(arr.timezone, f.actual_arrival) AS actual_arrival_local,
       (f.actual_arrival - f.actual_departure) AS actual_duration
FROM flights f,
     airports dep,
     airports arr
WHERE ((f.departure_airport = dep.airport_code) AND (f.arrival_airport = arr.airport_code));


--
-- Name: VIEW flights_v; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON VIEW flights_v IS 'Flights (extended)';


--
-- Name: COLUMN flights_v.flight_id; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.flight_id IS 'Flight ID';


--
-- Name: COLUMN flights_v.flight_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.flight_no IS 'Flight number';


--
-- Name: COLUMN flights_v.scheduled_departure; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.scheduled_departure IS 'Scheduled departure time';


--
-- Name: COLUMN flights_v.scheduled_departure_local; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.scheduled_departure_local IS 'Scheduled departure time, local time at the point of departure';


--
-- Name: COLUMN flights_v.scheduled_arrival; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.scheduled_arrival IS 'Scheduled arrival time';


--
-- Name: COLUMN flights_v.scheduled_arrival_local; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.scheduled_arrival_local IS 'Scheduled arrival time, local time at the point of destination';


--
-- Name: COLUMN flights_v.scheduled_duration; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.scheduled_duration IS 'Scheduled flight duration';


--
-- Name: COLUMN flights_v.departure_airport; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.departure_airport IS 'Deprature airport code';


--
-- Name: COLUMN flights_v.departure_airport_name; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.departure_airport_name IS 'Departure airport name';


--
-- Name: COLUMN flights_v.departure_city; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.departure_city IS 'City of departure';


--
-- Name: COLUMN flights_v.arrival_airport; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.arrival_airport IS 'Arrival airport code';


--
-- Name: COLUMN flights_v.arrival_airport_name; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.arrival_airport_name IS 'Arrival airport name';


--
-- Name: COLUMN flights_v.arrival_city; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.arrival_city IS 'City of arrival';


--
-- Name: COLUMN flights_v.status; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.status IS 'Flight status';


--
-- Name: COLUMN flights_v.aircraft_code; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.aircraft_code IS 'Aircraft code, IATA';


--
-- Name: COLUMN flights_v.actual_departure; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.actual_departure IS 'Actual departure time';


--
-- Name: COLUMN flights_v.actual_departure_local; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.actual_departure_local IS 'Actual departure time, local time at the point of departure';


--
-- Name: COLUMN flights_v.actual_arrival; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.actual_arrival IS 'Actual arrival time';


--
-- Name: COLUMN flights_v.actual_arrival_local; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.actual_arrival_local IS 'Actual arrival time, local time at the point of destination';


--
-- Name: COLUMN flights_v.actual_duration; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.actual_duration IS 'Actual flight duration';


--
-- Name: routes; Type: VIEW; Schema: bookings; Owner: -
--

CREATE VIEW routes AS
WITH f3 AS (
    SELECT f2.flight_no,
           f2.departure_airport,
           f2.arrival_airport,
           f2.aircraft_code,
           f2.duration,
           array_agg(f2.days_of_week) AS days_of_week
    FROM ( SELECT f1.flight_no,
                  f1.departure_airport,
                  f1.arrival_airport,
                  f1.aircraft_code,
                  f1.duration,
                  f1.days_of_week
           FROM ( SELECT flights.flight_no,
                         flights.departure_airport,
                         flights.arrival_airport,
                         flights.aircraft_code,
                         (flights.scheduled_arrival - flights.scheduled_departure) AS duration,
                         (to_char(flights.scheduled_departure, 'ID'::text))::integer AS days_of_week
                  FROM flights) f1
           GROUP BY f1.flight_no, f1.departure_airport, f1.arrival_airport, f1.aircraft_code, f1.duration, f1.days_of_week
           ORDER BY f1.flight_no, f1.departure_airport, f1.arrival_airport, f1.aircraft_code, f1.duration, f1.days_of_week) f2
    GROUP BY f2.flight_no, f2.departure_airport, f2.arrival_airport, f2.aircraft_code, f2.duration
)
SELECT f3.flight_no,
       f3.departure_airport,
       dep.airport_name AS departure_airport_name,
       dep.city AS departure_city,
       f3.arrival_airport,
       arr.airport_name AS arrival_airport_name,
       arr.city AS arrival_city,
       f3.aircraft_code,
       f3.duration,
       f3.days_of_week
FROM f3,
     airports dep,
     airports arr
WHERE ((f3.departure_airport = dep.airport_code) AND (f3.arrival_airport = arr.airport_code));


--
-- Name: VIEW routes; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON VIEW routes IS 'Routes';


--
-- Name: COLUMN routes.flight_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN routes.flight_no IS 'Flight number';


--
-- Name: COLUMN routes.departure_airport; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN routes.departure_airport IS 'Code of airport of departure';


--
-- Name: COLUMN routes.departure_airport_name; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN routes.departure_airport_name IS 'Name of airport of departure';


--
-- Name: COLUMN routes.departure_city; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN routes.departure_city IS 'City of departure';


--
-- Name: COLUMN routes.arrival_airport; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN routes.arrival_airport IS 'Code of airport of arrival';


--
-- Name: COLUMN routes.arrival_airport_name; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN routes.arrival_airport_name IS 'Name of airport of arrival';


--
-- Name: COLUMN routes.arrival_city; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN routes.arrival_city IS 'City of arrival';


--
-- Name: COLUMN routes.aircraft_code; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN routes.aircraft_code IS 'Aircraft code, IATA';


--
-- Name: COLUMN routes.duration; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN routes.duration IS 'Scheduled duration of flight';


--
-- Name: COLUMN routes.days_of_week; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN routes.days_of_week IS 'Days of week on which flights are scheduled';


--
-- Name: seats; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE seats (
                       aircraft_code character(3) NOT NULL,
                       seat_no character varying(4) NOT NULL,
                       fare_conditions character varying(10) NOT NULL,
                       CONSTRAINT seats_fare_conditions_check CHECK (((fare_conditions)::text = ANY (ARRAY[('Economy'::character varying)::text, ('Comfort'::character varying)::text, ('Business'::character varying)::text])))
);


--
-- Name: TABLE seats; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE seats IS 'Seats';


--
-- Name: COLUMN seats.aircraft_code; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN seats.aircraft_code IS 'Aircraft code, IATA';


--
-- Name: COLUMN seats.seat_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN seats.seat_no IS 'Seat number';


--
-- Name: COLUMN seats.fare_conditions; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN seats.fare_conditions IS 'Travel class';


--
-- Name: ticket_flights; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE ticket_flights (
                                ticket_no character(13) NOT NULL,
                                flight_id integer NOT NULL,
                                fare_conditions character varying(10) NOT NULL,
                                amount numeric(10,2) NOT NULL,
                                CONSTRAINT ticket_flights_amount_check CHECK ((amount >= (0)::numeric)),
                                CONSTRAINT ticket_flights_fare_conditions_check CHECK (((fare_conditions)::text = ANY (ARRAY[('Economy'::character varying)::text, ('Comfort'::character varying)::text, ('Business'::character varying)::text])))
);


--
-- Name: TABLE ticket_flights; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE ticket_flights IS 'Flight segment';


--
-- Name: COLUMN ticket_flights.ticket_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN ticket_flights.ticket_no IS 'Ticket number';


--
-- Name: COLUMN ticket_flights.flight_id; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN ticket_flights.flight_id IS 'Flight ID';


--
-- Name: COLUMN ticket_flights.fare_conditions; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN ticket_flights.fare_conditions IS 'Travel class';


--
-- Name: COLUMN ticket_flights.amount; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN ticket_flights.amount IS 'Travel cost';


--
-- Name: tickets; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE tickets (
                         ticket_no character(13) NOT NULL,
                         book_ref character(6) NOT NULL,
                         passenger_id character varying(20) NOT NULL,
                         passenger_name text NOT NULL,
                         contact_data jsonb
);


--
-- Name: TABLE tickets; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE tickets IS 'Tickets';


--
-- Name: COLUMN tickets.ticket_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN tickets.ticket_no IS 'Ticket number';


--
-- Name: COLUMN tickets.book_ref; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN tickets.book_ref IS 'Booking number';


--
-- Name: COLUMN tickets.passenger_id; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN tickets.passenger_id IS 'Passenger ID';


--
-- Name: COLUMN tickets.passenger_name; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN tickets.passenger_name IS 'Passenger name';


--
-- Name: COLUMN tickets.contact_data; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN tickets.contact_data IS 'Passenger contact information';


--
-- Name: flights flight_id; Type: DEFAULT; Schema: bookings; Owner: -
--

ALTER TABLE ONLY flights ALTER COLUMN flight_id SET DEFAULT nextval('flights_flight_id_seq'::regclass);


--
-- Data for Name: aircrafts_data; Type: TABLE DATA; Schema: bookings; Owner: -
--

COPY aircrafts_data (aircraft_code, model, range) FROM stdin;
773	{"en": "Boeing 777-300", "ru": "Боинг 777-300"}	11100
763	{"en": "Boeing 767-300", "ru": "Боинг 767-300"}	7900
SU9	{"en": "Sukhoi Superjet-100", "ru": "Сухой Суперджет-100"}	3000
320	{"en": "Airbus A320-200", "ru": "Аэробус A320-200"}	5700
321	{"en": "Airbus A321-200", "ru": "Аэробус A321-200"}	5600
319	{"en": "Airbus A319-100", "ru": "Аэробус A319-100"}	6700
733	{"en": "Boeing 737-300", "ru": "Боинг 737-300"}	4200
CN1	{"en": "Cessna 208 Caravan", "ru": "Сессна 208 Караван"}	1200
CR2	{"en": "Bombardier CRJ-200", "ru": "Бомбардье CRJ-200"}	2700
\.


--
-- Data for Name: airports_data; Type: TABLE DATA; Schema: bookings; Owner: -
--

COPY airports_data (airport_code, airport_name, city, coordinates, timezone) FROM stdin;
YKS	{"en": "Yakutsk Airport", "ru": "Якутск"}	{"en": "Yakutsk", "ru": "Якутск"}	(129.77099609375,62.0932998657226562)	Asia/Yakutsk
MJZ	{"en": "Mirny Airport", "ru": "Мирный"}	{"en": "Mirnyj", "ru": "Мирный"}	(114.03900146484375,62.534698486328125)	Asia/Yakutsk
KHV	{"en": "Khabarovsk-Novy Airport", "ru": "Хабаровск-Новый"}	{"en": "Khabarovsk", "ru": "Хабаровск"}	(135.18800354004,48.5279998779300001)	Asia/Vladivostok
PKC	{"en": "Yelizovo Airport", "ru": "Елизово"}	{"en": "Petropavlovsk", "ru": "Петропавловск-Камчатский"}	(158.453994750976562,53.1679000854492188)	Asia/Kamchatka
UUS	{"en": "Yuzhno-Sakhalinsk Airport", "ru": "Хомутово"}	{"en": "Yuzhno-Sakhalinsk", "ru": "Южно-Сахалинск"}	(142.718002319335938,46.8886985778808594)	Asia/Sakhalin
VVO	{"en": "Vladivostok International Airport", "ru": "Владивосток"}	{"en": "Vladivostok", "ru": "Владивосток"}	(132.147994995117188,43.3989982604980469)	Asia/Vladivostok
LED	{"en": "Pulkovo Airport", "ru": "Пулково"}	{"en": "St. Petersburg", "ru": "Санкт-Петербург"}	(30.2625007629394531,59.8003005981445312)	Europe/Moscow
KGD	{"en": "Khrabrovo Airport", "ru": "Храброво"}	{"en": "Kaliningrad", "ru": "Калининград"}	(20.5925998687744141,54.8899993896484375)	Europe/Kaliningrad
KEJ	{"en": "Kemerovo Airport", "ru": "Кемерово"}	{"en": "Kemorovo", "ru": "Кемерово"}	(86.1072006225585938,55.2700996398925781)	Asia/Novokuznetsk
CEK	{"en": "Chelyabinsk Balandino Airport", "ru": "Челябинск"}	{"en": "Chelyabinsk", "ru": "Челябинск"}	(61.503300000000003,55.3058010000000024)	Asia/Yekaterinburg
MQF	{"en": "Magnitogorsk International Airport", "ru": "Магнитогорск"}	{"en": "Magnetiogorsk", "ru": "Магнитогорск"}	(58.7556991577148438,53.3931007385253906)	Asia/Yekaterinburg
PEE	{"en": "Bolshoye Savino Airport", "ru": "Пермь"}	{"en": "Perm", "ru": "Пермь"}	(56.021198272705,57.9145011901860016)	Asia/Yekaterinburg
SGC	{"en": "Surgut Airport", "ru": "Сургут"}	{"en": "Surgut", "ru": "Сургут"}	(73.4018020629882812,61.3437004089355469)	Asia/Yekaterinburg
BZK	{"en": "Bryansk Airport", "ru": "Брянск"}	{"en": "Bryansk", "ru": "Брянск"}	(34.1763992309999978,53.2141990661999955)	Europe/Moscow
MRV	{"en": "Mineralnyye Vody Airport", "ru": "Минеральные Воды"}	{"en": "Mineralnye Vody", "ru": "Минеральные Воды"}	(43.0819015502929688,44.2251014709472656)	Europe/Moscow
STW	{"en": "Stavropol Shpakovskoye Airport", "ru": "Ставрополь"}	{"en": "Stavropol", "ru": "Ставрополь"}	(42.1128005981445312,45.1091995239257812)	Europe/Moscow
ASF	{"en": "Astrakhan Airport", "ru": "Астрахань"}	{"en": "Astrakhan", "ru": "Астрахань"}	(48.0063018799000005,46.2832984924000002)	Europe/Samara
NJC	{"en": "Nizhnevartovsk Airport", "ru": "Нижневартовск"}	{"en": "Nizhnevartovsk", "ru": "Нижневартовск"}	(76.4835968017578125,60.9492988586425781)	Asia/Yekaterinburg
SVX	{"en": "Koltsovo Airport", "ru": "Кольцово"}	{"en": "Yekaterinburg", "ru": "Екатеринбург"}	(60.8027000427250002,56.7430992126460012)	Asia/Yekaterinburg
SVO	{"en": "Sheremetyevo International Airport", "ru": "Шереметьево"}	{"en": "Moscow", "ru": "Москва"}	(37.4146000000000001,55.9725990000000024)	Europe/Moscow
VOZ	{"en": "Voronezh International Airport", "ru": "Воронеж"}	{"en": "Voronezh", "ru": "Воронеж"}	(39.2295989990234375,51.8142013549804688)	Europe/Moscow
VKO	{"en": "Vnukovo International Airport", "ru": "Внуково"}	{"en": "Moscow", "ru": "Москва"}	(37.2615013122999983,55.5914993286000012)	Europe/Moscow
SCW	{"en": "Syktyvkar Airport", "ru": "Сыктывкар"}	{"en": "Syktyvkar", "ru": "Сыктывкар"}	(50.8451004028320312,61.6469993591308594)	Europe/Moscow
KUF	{"en": "Kurumoch International Airport", "ru": "Курумоч"}	{"en": "Samara", "ru": "Самара"}	(50.1642990112299998,53.5049018859860013)	Europe/Samara
DME	{"en": "Domodedovo International Airport", "ru": "Домодедово"}	{"en": "Moscow", "ru": "Москва"}	(37.9062995910644531,55.4087982177734375)	Europe/Moscow
TJM	{"en": "Roshchino International Airport", "ru": "Рощино"}	{"en": "Tyumen", "ru": "Тюмень"}	(65.3243026732999965,57.1896018981999958)	Asia/Yekaterinburg
GOJ	{"en": "Nizhny Novgorod Strigino International Airport", "ru": "Стригино"}	{"en": "Nizhniy Novgorod", "ru": "Нижний Новгород"}	(43.7840003967289988,56.2300987243649999)	Europe/Moscow
TOF	{"en": "Bogashevo Airport", "ru": "Богашёво"}	{"en": "Tomsk", "ru": "Томск"}	(85.2082977294920028,56.3802986145020029)	Asia/Krasnoyarsk
UIK	{"en": "Ust-Ilimsk Airport", "ru": "Усть-Илимск"}	{"en": "Ust Ilimsk", "ru": "Усть-Илимск"}	(102.56500244140625,58.1361007690429688)	Asia/Irkutsk
NSK	{"en": "Norilsk-Alykel Airport", "ru": "Норильск"}	{"en": "Norilsk", "ru": "Норильск"}	(87.3321990966796875,69.31109619140625)	Asia/Krasnoyarsk
ARH	{"en": "Talagi Airport", "ru": "Талаги"}	{"en": "Arkhangelsk", "ru": "Архангельск"}	(40.7167015075683594,64.6003036499023438)	Europe/Moscow
RTW	{"en": "Saratov Central Airport", "ru": "Саратов-Центральный"}	{"en": "Saratov", "ru": "Саратов"}	(46.0466995239257812,51.5649986267089844)	Europe/Volgograd
NUX	{"en": "Novy Urengoy Airport", "ru": "Новый Уренгой"}	{"en": "Novy Urengoy", "ru": "Новый Уренгой"}	(76.5203018188476562,66.06939697265625)	Asia/Yekaterinburg
NOJ	{"en": "Noyabrsk Airport", "ru": "Ноябрьск"}	{"en": "Noyabrsk", "ru": "Ноябрьск"}	(75.2699966430664062,63.1833000183105469)	Asia/Yekaterinburg
UCT	{"en": "Ukhta Airport", "ru": "Ухта"}	{"en": "Ukhta", "ru": "Ухта"}	(53.8046989440917969,63.5668983459472656)	Europe/Moscow
USK	{"en": "Usinsk Airport", "ru": "Усинск"}	{"en": "Usinsk", "ru": "Усинск"}	(57.3671989440917969,66.00469970703125)	Europe/Moscow
NNM	{"en": "Naryan Mar Airport", "ru": "Нарьян-Мар"}	{"en": "Naryan-Mar", "ru": "Нарьян-Мар"}	(53.1218986511230469,67.6399993896484375)	Europe/Moscow
PKV	{"en": "Pskov Airport", "ru": "Псков"}	{"en": "Pskov", "ru": "Псков"}	(28.395599365234375,57.7839012145996094)	Europe/Moscow
KGP	{"en": "Kogalym International Airport", "ru": "Когалым"}	{"en": "Kogalym", "ru": "Когалым"}	(74.5337982177734375,62.190399169921875)	Asia/Yekaterinburg
KJA	{"en": "Yemelyanovo Airport", "ru": "Емельяново"}	{"en": "Krasnoyarsk", "ru": "Красноярск"}	(92.493301391602003,56.1729011535639984)	Asia/Krasnoyarsk
URJ	{"en": "Uray Airport", "ru": "Петрозаводск"}	{"en": "Uraj", "ru": "Урай"}	(64.8266983032226562,60.1032981872558594)	Asia/Yekaterinburg
IWA	{"en": "Ivanovo South Airport", "ru": "Иваново-Южный"}	{"en": "Ivanovo", "ru": "Иваново"}	(40.9407997131347656,56.9393997192382812)	Europe/Moscow
PYJ	{"en": "Polyarny Airport", "ru": "Полярный"}	{"en": "Yakutia", "ru": "Удачный"}	(112.029998778999996,66.4003982544000024)	Asia/Yakutsk
KXK	{"en": "Komsomolsk-on-Amur Airport", "ru": "Хурба"}	{"en": "Komsomolsk-on-Amur", "ru": "Комсомольск-на-Амуре"}	(136.934005737304688,50.4090003967285156)	Asia/Vladivostok
DYR	{"en": "Ugolny Airport", "ru": "Анадырь"}	{"en": "Anadyr", "ru": "Анадырь"}	(177.740997314453125,64.7349014282226562)	Asia/Anadyr
PES	{"en": "Petrozavodsk Airport", "ru": "Бесовец"}	{"en": "Petrozavodsk", "ru": "Петрозаводск"}	(34.1547012329101562,61.8852005004882812)	Europe/Moscow
KYZ	{"en": "Kyzyl Airport", "ru": "Кызыл"}	{"en": "Kyzyl", "ru": "Кызыл"}	(94.4005966186523438,51.6693992614746094)	Asia/Krasnoyarsk
NOZ	{"en": "Spichenkovo Airport", "ru": "Спиченково"}	{"en": "Novokuznetsk", "ru": "Новокузнецк"}	(86.877197265625,53.8114013671875)	Asia/Novokuznetsk
GRV	{"en": "Khankala Air Base", "ru": "Грозный"}	{"en": "Grozny", "ru": "Грозный"}	(45.7840995788574219,43.2980995178222656)	Europe/Moscow
NAL	{"en": "Nalchik Airport", "ru": "Нальчик"}	{"en": "Nalchik", "ru": "Нальчик"}	(43.6366004943847656,43.5129013061523438)	Europe/Moscow
OGZ	{"en": "Beslan Airport", "ru": "Беслан"}	{"en": "Beslan", "ru": "Владикавказ"}	(44.6066017150999983,43.2051010132000002)	Europe/Moscow
ESL	{"en": "Elista Airport", "ru": "Элиста"}	{"en": "Elista", "ru": "Элиста"}	(44.3308982849121094,46.3739013671875)	Europe/Moscow
SLY	{"en": "Salekhard Airport", "ru": "Салехард"}	{"en": "Salekhard", "ru": "Салехард"}	(66.6110000610351562,66.5907974243164062)	Asia/Yekaterinburg
HMA	{"en": "Khanty Mansiysk Airport", "ru": "Ханты-Мансийск"}	{"en": "Khanty-Mansiysk", "ru": "Ханты-Мансийск"}	(69.0860977172851562,61.0284996032714844)	Asia/Yekaterinburg
NYA	{"en": "Nyagan Airport", "ru": "Нягань"}	{"en": "Nyagan", "ru": "Нягань"}	(65.6149978637695312,62.1100006103515625)	Asia/Yekaterinburg
OVS	{"en": "Sovetskiy Airport", "ru": "Советский"}	{"en": "Sovetskiy", "ru": "Советский"}	(63.6019134521484375,61.3266220092773438)	Asia/Yekaterinburg
IJK	{"en": "Izhevsk Airport", "ru": "Ижевск"}	{"en": "Izhevsk", "ru": "Ижевск"}	(53.4575004577636719,56.8280982971191406)	Europe/Samara
KVX	{"en": "Pobedilovo Airport", "ru": "Победилово"}	{"en": "Kirov", "ru": "Киров"}	(49.3483009338379972,58.5032997131350001)	Europe/Moscow
NYM	{"en": "Nadym Airport", "ru": "Надым"}	{"en": "Nadym", "ru": "Надым"}	(72.6988983154296875,65.4809036254882812)	Asia/Yekaterinburg
NFG	{"en": "Nefteyugansk Airport", "ru": "Нефтеюганск"}	{"en": "Nefteyugansk", "ru": "Нефтеюганск"}	(72.6500015258789062,61.1082992553710938)	Asia/Yekaterinburg
KRO	{"en": "Kurgan Airport", "ru": "Курган"}	{"en": "Kurgan", "ru": "Курган"}	(65.4156036376953125,55.4752998352050781)	Asia/Yekaterinburg
EGO	{"en": "Belgorod International Airport", "ru": "Белгород"}	{"en": "Belgorod", "ru": "Белгород"}	(36.5900993347167969,50.643798828125)	Europe/Moscow
URS	{"en": "Kursk East Airport", "ru": "Курск-Восточный"}	{"en": "Kursk", "ru": "Курск"}	(36.2956008911132812,51.7505989074707031)	Europe/Moscow
LPK	{"en": "Lipetsk Airport", "ru": "Липецк"}	{"en": "Lipetsk", "ru": "Липецк"}	(39.5377998352050781,52.7028007507324219)	Europe/Moscow
VKT	{"en": "Vorkuta Airport", "ru": "Воркута"}	{"en": "Vorkuta", "ru": "Воркута"}	(63.9930992126464844,67.4886016845703125)	Europe/Moscow
UUA	{"en": "Bugulma Airport", "ru": "Бугульма"}	{"en": "Bugulma", "ru": "Бугульма"}	(52.8017005920410156,54.6399993896484375)	Europe/Moscow
JOK	{"en": "Yoshkar-Ola Airport", "ru": "Йошкар-Ола"}	{"en": "Yoshkar-Ola", "ru": "Йошкар-Ола"}	(47.9047012329101562,56.7005996704101562)	Europe/Moscow
CSY	{"en": "Cheboksary Airport", "ru": "Чебоксары"}	{"en": "Cheboksary", "ru": "Чебоксары"}	(47.3473014831542969,56.090301513671875)	Europe/Moscow
ULY	{"en": "Ulyanovsk East Airport", "ru": "Ульяновск-Восточный"}	{"en": "Ulyanovsk", "ru": "Ульяновск"}	(48.8027000427246094,54.4010009765625)	Europe/Samara
OSW	{"en": "Orsk Airport", "ru": "Орск"}	{"en": "Orsk", "ru": "Орск"}	(58.5956001281738281,51.0724983215332031)	Asia/Yekaterinburg
PEZ	{"en": "Penza Airport", "ru": "Пенза"}	{"en": "Penza", "ru": "Пенза"}	(45.0210990905761719,53.1105995178222656)	Europe/Moscow
SKX	{"en": "Saransk Airport", "ru": "Саранск"}	{"en": "Saransk", "ru": "Саранск"}	(45.2122573852539062,54.1251296997070312)	Europe/Moscow
TBW	{"en": "Donskoye Airport", "ru": "Донское"}	{"en": "Tambow", "ru": "Тамбов"}	(41.4827995300289984,52.806098937987997)	Europe/Moscow
UKX	{"en": "Ust-Kut Airport", "ru": "Усть-Кут"}	{"en": "Ust-Kut", "ru": "Усть-Кут"}	(105.730003356933594,56.8567008972167969)	Asia/Irkutsk
GDZ	{"en": "Gelendzhik Airport", "ru": "Геленджик"}	{"en": "Gelendzhik", "ru": "Геленджик"}	(38.012480735799997,44.5820926295000035)	Europe/Moscow
IAR	{"en": "Tunoshna Airport", "ru": "Туношна"}	{"en": "Yaroslavl", "ru": "Ярославль"}	(40.1573982238769531,57.560699462890625)	Europe/Moscow
NBC	{"en": "Begishevo Airport", "ru": "Бегишево"}	{"en": "Nizhnekamsk", "ru": "Нижнекамск"}	(52.092498779296875,55.5647010803222656)	Europe/Moscow
ULV	{"en": "Ulyanovsk Baratayevka Airport", "ru": "Баратаевка"}	{"en": "Ulyanovsk", "ru": "Ульяновск"}	(48.2266998291000064,54.2682991027999932)	Europe/Samara
SWT	{"en": "Strezhevoy Airport", "ru": "Стрежевой"}	{"en": "Strezhevoy", "ru": "Стрежевой"}	(77.66000366210001,60.7094001769999991)	Asia/Krasnoyarsk
EYK	{"en": "Beloyarskiy Airport", "ru": "Белоярский"}	{"en": "Beloyarsky", "ru": "Белоярский"}	(66.6986007689999951,63.6869010924999941)	Asia/Yekaterinburg
KLF	{"en": "Grabtsevo Airport", "ru": "Калуга"}	{"en": "Kaluga", "ru": "Калуга"}	(36.3666687011999983,54.5499992371000033)	Europe/Moscow
RGK	{"en": "Gorno-Altaysk Airport", "ru": "Горно-Алтайск"}	{"en": "Gorno-Altaysk", "ru": "Горно-Алтайск"}	(85.8332977295000035,51.9667015075999998)	Asia/Krasnoyarsk
KRR	{"en": "Krasnodar Pashkovsky International Airport", "ru": "Краснодар"}	{"en": "Krasnodar", "ru": "Краснодар"}	(39.1705017089839984,45.0346984863279971)	Europe/Moscow
MCX	{"en": "Uytash Airport", "ru": "Уйташ"}	{"en": "Makhachkala", "ru": "Махачкала"}	(47.6523017883300781,42.8167991638183594)	Europe/Moscow
KZN	{"en": "Kazan International Airport", "ru": "Казань"}	{"en": "Kazan", "ru": "Казань"}	(49.278701782227003,55.606201171875)	Europe/Moscow
REN	{"en": "Orenburg Central Airport", "ru": "Оренбург-Центральный"}	{"en": "Orenburg", "ru": "Оренбург"}	(55.4566993713378906,51.7957992553710938)	Asia/Yekaterinburg
UFA	{"en": "Ufa International Airport", "ru": "Уфа"}	{"en": "Ufa", "ru": "Уфа"}	(55.8744010925289984,54.5574989318850001)	Asia/Yekaterinburg
OVB	{"en": "Tolmachevo Airport", "ru": "Толмачёво"}	{"en": "Novosibirsk", "ru": "Новосибирск"}	(82.6507034301759944,55.012599945067997)	Asia/Novosibirsk
CEE	{"en": "Cherepovets Airport", "ru": "Череповец"}	{"en": "Cherepovets", "ru": "Череповец"}	(38.0158004761000043,59.2736015320000007)	Europe/Moscow
OMS	{"en": "Omsk Central Airport", "ru": "Омск-Центральный"}	{"en": "Omsk", "ru": "Омск"}	(73.3105010986328125,54.9669990539550781)	Asia/Omsk
ROV	{"en": "Rostov-on-Don Airport", "ru": "Ростов-на-Дону"}	{"en": "Rostov", "ru": "Ростов-на-Дону"}	(39.8180999755999991,47.2582015990999977)	Europe/Moscow
AER	{"en": "Sochi International Airport", "ru": "Сочи"}	{"en": "Sochi", "ru": "Сочи"}	(39.9566001892089986,43.4499015808110016)	Europe/Moscow
VOG	{"en": "Volgograd International Airport", "ru": "Гумрак"}	{"en": "Volgograd", "ru": "Волгоград"}	(44.3455009460449219,48.782501220703125)	Europe/Volgograd
BQS	{"en": "Ignatyevo Airport", "ru": "Игнатьево"}	{"en": "Blagoveschensk", "ru": "Благовещенск"}	(127.412002563476562,50.4253997802734375)	Asia/Yakutsk
GDX	{"en": "Sokol Airport", "ru": "Магадан"}	{"en": "Magadan", "ru": "Магадан"}	(150.720001220703125,59.9109992980957031)	Asia/Magadan
HTA	{"en": "Chita-Kadala Airport", "ru": "Чита"}	{"en": "Chita", "ru": "Чита"}	(113.305999999999997,52.0262990000000016)	Asia/Chita
BTK	{"en": "Bratsk Airport", "ru": "Братск"}	{"en": "Bratsk", "ru": "Братск"}	(101.697998046875,56.3706016540527344)	Asia/Irkutsk
IKT	{"en": "Irkutsk Airport", "ru": "Иркутск"}	{"en": "Irkutsk", "ru": "Иркутск"}	(104.388999938959998,52.2680015563960012)	Asia/Irkutsk
UUD	{"en": "Ulan-Ude Airport (Mukhino)", "ru": "Байкал"}	{"en": "Ulan-ude", "ru": "Улан-Удэ"}	(107.438003540039062,51.80780029296875)	Asia/Irkutsk
MMK	{"en": "Murmansk Airport", "ru": "Мурманск"}	{"en": "Murmansk", "ru": "Мурманск"}	(32.7508010864257812,68.7817001342773438)	Europe/Moscow
ABA	{"en": "Abakan Airport", "ru": "Абакан"}	{"en": "Abakan", "ru": "Абакан"}	(91.3850021362304688,53.7400016784667969)	Asia/Krasnoyarsk
BAX	{"en": "Barnaul Airport", "ru": "Барнаул"}	{"en": "Barnaul", "ru": "Барнаул"}	(83.5384979248046875,53.363800048828125)	Asia/Krasnoyarsk
AAQ	{"en": "Anapa Vityazevo Airport", "ru": "Витязево"}	{"en": "Anapa", "ru": "Анапа"}	(37.3473014831539984,45.002101898192997)	Europe/Moscow
CNN	{"en": "Chulman Airport", "ru": "Чульман"}	{"en": "Neryungri", "ru": "Нерюнгри"}	(124.914001464839998,56.9138984680179973)	Asia/Yakutsk
\.


--
-- Data for Name: boarding_passes; Type: TABLE DATA; Schema: bookings; Owner: -
--

COPY boarding_passes (ticket_no, flight_id, boarding_no, seat_no) FROM stdin;
0005435212351	30625	1	2D
0005435212386	30625	2	3G
0005435212381	30625	3	4H
0005432211370	30625	4	5D
0005435212357	30625	5	11A
0005435212360	30625	6	11E
0005435212393	30625	7	11H
0005435212374	30625	8	12E
0005435212365	30625	9	13D
0005435212378	30625	10	14H
0005435212362	30625	11	15E
0005435212334	30625	12	15F
0005435212370	30625	13	15K
0005435212329	30625	14	15H
0005435725513	30625	15	16D
0005435212328	30625	16	16C
0005435630915	30625	17	16E
0005435212388	30625	18	17E
0005432159775	30625	19	17D
0005435212382	30625	20	17H
0005432211367	30625	21	19K
0005435212354	30625	22	20B
0005432211372	30625	23	20F
0005432159776	30625	24	2A
0005435212344	30625	25	20K
0005435212372	30625	26	22B
0005435212355	30625	27	22H
0005435212376	30625	28	23F
0005435725512	30625	29	25D
0005435212385	30625	30	25C
0005435212336	30625	31	26D
0005435212367	30625	32	26J
0005435212359	30625	33	27B
0005435212364	30625	34	27H
0005435725514	30625	35	27K
0005435212338	30625	36	28C
0005435212391	30625	37	28B
0005435212366	30625	38	28G
0005435212347	30625	39	28J
0005432211366	30625	40	28K
0005433656614	30625	41	29D
0005435212383	30625	42	29C
0005435212373	30625	43	29B
0005435212395	30625	44	29J
0005435212343	30625	45	30E
0005435212371	30625	46	30J
0005435212377	30625	47	31J
0005435212358	30625	48	32C
0005435212330	30625	49	32B
0005432211371	30625	50	32F
0005435212368	30625	51	32K
0005435212340	30625	52	33D
0005435212335	30625	53	33C
0005435212363	30625	54	33H
0005435212380	30625	55	35A
0005435212345	30625	56	35C
0005435212375	30625	57	35B
0005432211365	30625	58	35F
0005435212350	30625	59	35E
0005435212331	30625	60	35G
0005435212353	30625	61	36G
0005435630916	30625	62	36J
0005435212337	30625	63	37B
0005432211368	30625	64	37E
0005432211369	30625	65	37F
0005435212356	30625	66	37H
0005435212332	30625	67	38A
0005435212348	30625	68	38K
0005435212352	30625	69	39E
0005435212394	30625	70	40G
0005435212389	30625	71	40J
0005435212369	30625	72	42A
0005435212392	30625	73	41K
0005435212379	30625	74	42C
0005435725516	30625	75	42E
0005435212396	30625	76	42K
0005432159777	30625	77	43A
0005433656613	30625	78	43G
0005435725515	30625	79	43H
0005435212346	30625	80	43K
0005435212390	30625	81	45D
0005435212361	30625	82	45E
0005435212341	30625	83	45K
0005435725511	30625	84	46C
0005435212349	30625	85	46B
0005432159778	30625	86	46K
0005435212384	30625	87	47E
0005435630914	30625	88	49E
0005435212339	30625	89	49G
0005435212333	30625	90	50C
0005435212387	30625	91	50H
0005435212342	30625	92	51D
0005433367244	24836	1	1D
0005433367229	24836	2	1F
0005433367230	24836	3	2C
0005433367245	24836	4	2D
0005433367256	24836	5	3D
0005433367225	24836	6	3F
0005433367228	24836	7	4A
0005433367236	24836	8	4C
0005433367252	24836	9	4E
0005433367243	24836	10	5A
0005433367222	24836	11	5C
0005433367234	24836	12	5D
0005433367231	24836	13	5F
0005433367218	24836	14	6C
0005433367224	24836	15	6E
0005433367237	24836	16	7A
0005433367255	24836	17	7D
0005433367246	24836	18	7E
0005433367227	24836	19	8A
0005433367233	24836	20	8F
0005433367242	24836	21	9A
0005433367248	24836	22	9F
0005433367223	24836	23	10C
0005433367241	24836	24	10E
0005433367221	24836	25	10F
0005433367258	24836	26	11A
0005433367240	24836	27	13E
0005433367226	24836	28	13F
0005433367247	24836	29	14A
0005433367235	24836	30	14F
0005433367257	24836	31	15F
0005433367251	24836	32	16A
0005433367239	24836	33	16C
0005433367220	24836	34	16D
0005433367250	24836	35	16E
0005433367219	24836	36	17C
0005433367253	24836	37	17D
0005433367232	24836	38	18A
0005433367249	24836	39	18E
0005433367238	24836	40	19D
0005433367254	24836	41	19E
0005434979262	2055	1	1C
0005434979271	2055	2	1D
0005434979277	2055	3	2B
0005434979252	2055	4	2C
0005434979282	2055	5	2D
0005434979273	2055	6	3B
0005434979280	2055	7	3C
0005434979255	2055	8	4A
0005434979269	2055	9	4B
0005434979275	2055	10	4C
0005435801642	2055	11	4D
0005434979279	2055	12	5A
0005434979267	2055	13	5B
0005434979254	2055	14	5D
0005434979264	2055	15	6A
0005434979263	2055	16	6C
0005434979276	2055	17	7B
0005434979270	2055	18	18A
0005434979258	2055	19	18B
0005434979256	2055	20	18C
0005434979265	2055	21	18D
0005434979261	2055	22	19A
0005434979253	2055	23	19B
0005434979259	2055	24	19D
0005435801643	2055	25	20A
0005434979272	2055	26	20B
0005434979260	2055	27	20C
0005434979274	2055	28	20D
0005434979268	2055	29	21C
0005434979257	2055	30	21D
0005434979278	2055	31	22A
0005434979266	2055	32	22B
0005435801644	2055	33	22D
0005434979281	2055	34	23B
0005434952466	2575	1	1B
0005434952464	2575	2	4A
0005434952467	2575	3	5A
0005434952465	2575	4	4B
0005433256382	28205	1	1B
0005433256381	28205	2	5A
0005433111467	19732	1	1A
0005433111468	19732	2	3B
0005433112350	19732	3	4B
0005433111469	19732	4	6A
0005434190367	19092	1	1C
0005434190368	19092	2	7A
0005433534460	6786	1	1B
0005433534461	6786	2	2A
0005433534463	6786	3	2D
0005433538721	6786	4	3A
0005433538717	6786	5	4B
0005433538718	6786	6	4C
0005433534462	6786	7	5C
0005433538720	6786	8	21A
0005433538719	6786	9	21B
0005433538722	6786	10	21D
0005433538723	6786	11	22A
0005433538724	6786	12	23B
0005435259680	25029	1	3D
0005435259678	25029	2	4C
0005435259681	25029	3	18A
0005435259679	25029	4	19D
0005433511804	823	1	1D
0005433511803	823	2	4B
0005433511809	823	3	5D
0005433511807	823	4	6A
0005433511802	823	5	7B
0005433511801	823	6	19B
0005433511808	823	7	20B
0005433511806	823	8	21B
0005433511805	823	9	22B
0005432922454	16157	1	1C
0005432922455	16157	2	2D
0005432922453	16157	3	5A
0005433475633	4021	1	1D
0005433475632	4021	2	2D
0005433475631	4021	3	18D
0005433475630	4021	4	21A
0005435696849	3660	1	1B
0005435696846	3660	2	1D
0005434950451	3660	3	2A
0005435696864	3660	4	2B
0005435696862	3660	5	2D
0005435696847	3660	6	3A
0005435696850	3660	7	3D
0005435696866	3660	8	4A
0005435696843	3660	9	4C
0005435696863	3660	10	5A
0005435696851	3660	11	5B
0005434950450	3660	12	5D
0005435696870	3660	13	6B
0005434950452	3660	14	6D
0005435696859	3660	15	7A
0005435696871	3660	16	7B
0005435696855	3660	17	7D
0005435696869	3660	18	18A
0005435696852	3660	19	18C
0005435696857	3660	20	18D
0005435696853	3660	21	19A
0005435696845	3660	22	19B
0005435696844	3660	23	19C
0005435696856	3660	24	20B
0005435696858	3660	25	20C
0005435696865	3660	26	20D
0005435696848	3660	27	21C
0005435696861	3660	28	22A
0005435696860	3660	29	22B
0005435696854	3660	30	22D
0005435696868	3660	31	23B
0005435696867	3660	32	23A
0005435916119	16272	1	6A
0005435916118	16272	2	7B
0005432609659	3993	1	1A
0005432609661	3993	2	1B
0005432607495	3993	3	1C
0005434606760	3993	4	1D
0005432609658	3993	5	2D
0005434606759	3993	6	4A
0005434606763	3993	7	4D
0005433519378	3993	8	5B
0005432607494	3993	9	6B
0005433519379	3993	10	6D
0005434604838	3993	11	7A
0005434606761	3993	12	18B
0005433519377	3993	13	19B
0005432609660	3993	14	19C
0005434604839	3993	15	19D
0005434606762	3993	16	20B
0005433519380	3993	17	20C
0005432607496	3993	18	21B
0005434604837	3993	19	21C
0005435853578	22080	1	1D
0005435853580	22080	2	18C
0005435853579	22080	3	22C
0005435628670	728	1	1A
0005435628672	728	2	2A
0005435628669	728	3	4B
0005435628671	728	4	6A
0005433348889	15900	1	1A
0005433348891	15900	2	2A
0005433348887	15900	3	3B
0005433348888	15900	4	5B
0005433348890	15900	5	6B
0005433159275	17677	1	4A
0005433159274	17677	2	6A
0005433159276	17677	3	6B
0005435132700	7862	1	2B
0005435132696	7862	2	2D
0005435132694	7862	3	3D
0005435132695	7862	4	4B
0005435132698	7862	5	5A
0005435132697	7862	6	6A
0005435132699	7862	7	7D
0005435132703	7862	8	19B
0005435132704	7862	9	20A
0005435132702	7862	10	21C
0005435132701	7862	11	23A
0005435383058	33092	1	1A
0005435383057	33092	2	5C
0005435383056	33092	3	6B
0005435383059	33092	4	18B
0005435383055	33092	5	22B
0005435160112	7477	1	4C
0005435160111	7477	2	6A
0005435160104	7477	3	7C
0005435160106	7477	4	7B
0005435160109	7477	5	18B
0005435160103	7477	6	18D
0005435160105	7477	7	20A
0005435160110	7477	8	21B
0005435160113	7477	9	21C
0005435160107	7477	10	21D
0005435160108	7477	11	23B
0005435390116	29573	1	1A
0005435390120	29573	2	4A
0005435390121	29573	3	4B
0005435390122	29573	4	5C
0005435390118	29573	5	7C
0005435390117	29573	6	21A
0005435390119	29573	7	21D
0005434503467	6547	1	2C
0005434503492	6547	2	2F
0005434503487	6547	3	4A
0005434503465	6547	4	4C
0005434503495	6547	5	4F
0005434503472	6547	6	5A
0005434503463	6547	7	5D
0005434503469	6547	8	5E
0005434503460	6547	9	5F
0005434503488	6547	10	6C
0005434503484	6547	11	6D
0005434503490	6547	12	6E
0005434503468	6547	13	6F
0005434503482	6547	14	7A
0005435103797	6547	15	7D
0005435103796	6547	16	7E
0005434503479	6547	17	8A
0005435103802	6547	18	8C
0005434503471	6547	19	8D
0005434503494	6547	20	8E
0005434503483	6547	21	8F
0005434503474	6547	22	9C
0005434503464	6547	23	9D
0005434503476	6547	24	9E
0005435103803	6547	25	10A
0005434503462	6547	26	10C
0005434503459	6547	27	10E
0005435103799	6547	28	10F
0005434503458	6547	29	11C
0005434503466	6547	30	11F
0005434503478	6547	31	12A
0005434503470	6547	32	12C
0005434503486	6547	33	13C
0005434503489	6547	34	13F
0005434503491	6547	35	14A
0005435103793	6547	36	14D
0005435103795	6547	37	14E
0005434503485	6547	38	14F
0005434503477	6547	39	15C
0005434503461	6547	40	15E
0005434503473	6547	41	15F
0005434503496	6547	42	16D
0005435103794	6547	43	16E
0005434503475	6547	44	17E
0005434503493	6547	45	17F
0005435103801	6547	46	18D
0005435103798	6547	47	19A
0005435103800	6547	48	20A
0005434503481	6547	49	20C
0005434503480	6547	50	20E
0005435652274	1654	1	1A
0005435652282	1654	2	1D
0005435652261	1654	3	2C
0005435652269	1654	4	2F
0005435652292	1654	5	3C
0005435652275	1654	6	4A
0005435652281	1654	7	4C
0005435652283	1654	8	5D
0005435652263	1654	9	5E
0005435652260	1654	10	6D
0005435652264	1654	11	6F
0005435652278	1654	12	7A
0005435652266	1654	13	7D
0005435652272	1654	14	7F
0005435652250	1654	15	8A
0005435652254	1654	16	8C
0005435652268	1654	17	8E
0005435652253	1654	18	9C
0005435652279	1654	19	9D
0005435652276	1654	20	9E
0005435652251	1654	21	10A
0005435652273	1654	22	10C
0005435652252	1654	23	11A
0005435652295	1654	24	11C
0005435652284	1654	25	11D
0005435652259	1654	26	11E
0005435652265	1654	27	12C
0005435652262	1654	28	12D
0005435652267	1654	29	12E
0005435652280	1654	30	13A
0005435652294	1654	31	13C
0005435652296	1654	32	13D
0005435652257	1654	33	13E
0005435652288	1654	34	14C
0005435652271	1654	35	14D
0005435652285	1654	36	15D
0005435652258	1654	37	15E
0005435652286	1654	38	15F
0005435652291	1654	39	16A
0005435652293	1654	40	16E
0005435652256	1654	41	16D
0005435652270	1654	42	17C
0005435652289	1654	43	18C
0005435652287	1654	44	18D
0005435652290	1654	45	19E
0005435652277	1654	46	19F
0005435652255	1654	47	20D
0005433367257	21707	1	1C
0005433367244	21707	2	1D
0005433367258	21707	3	1F
0005433367221	21707	4	2F
0005433367224	21707	5	4A
0005433367218	21707	6	4D
0005433367240	21707	7	4E
0005433367222	21707	8	6D
0005433367227	21707	9	6E
0005433367252	21707	10	6F
0005433367256	21707	11	7C
0005433367245	21707	12	7F
0005433367247	21707	13	8A
0005433367248	21707	14	8D
0005433367251	21707	15	8E
0005433367235	21707	16	9E
0005433367246	21707	17	10A
0005433367237	21707	18	10C
0005433367242	21707	19	10D
0005433367241	21707	20	10E
0005433367234	21707	21	10F
0005433367253	21707	22	11D
0005433367250	21707	23	11F
0005433367255	21707	24	13D
0005433367231	21707	25	13E
0005433367228	21707	26	14D
0005433367220	21707	27	14E
0005433367238	21707	28	15A
0005433367219	21707	29	15D
0005433367225	21707	30	16A
0005433367226	21707	31	16C
0005433367236	21707	32	16D
0005433367230	21707	33	17A
0005433367254	21707	34	17C
0005433367239	21707	35	18F
0005433367229	21707	36	19A
0005433367232	21707	37	19C
0005433367233	21707	38	19D
0005433367249	21707	39	19E
0005433367243	21707	40	20A
0005433367223	21707	41	20D
0005433985127	4135	1	1D
0005433985129	4135	2	1F
0005433985123	4135	3	2A
0005433985126	4135	4	2C
0005433985160	4135	5	2F
0005435788725	4135	6	3A
0005433985140	4135	7	3D
0005433985155	4135	8	3F
0005433985137	4135	9	4A
0005433985159	4135	10	4E
0005433985125	4135	11	5A
0005433985154	4135	12	5D
0005433985161	4135	13	5E
0005433985122	4135	14	5F
0005433985136	4135	15	7D
0005433985148	4135	16	8A
0005433985143	4135	17	8E
0005433985131	4135	18	9A
0005433985133	4135	19	9C
0005433985158	4135	20	9D
0005433985141	4135	21	10A
0005433985134	4135	22	10D
0005433985139	4135	23	10F
0005435788726	4135	24	11A
0005433985145	4135	25	11E
0005433985152	4135	26	12A
0005433985144	4135	27	12C
0005433985147	4135	28	12F
0005433985146	4135	29	13A
0005435788727	4135	30	13C
0005433985124	4135	31	13D
0005435788728	4135	32	13E
0005433985153	4135	33	14A
0005433985156	4135	34	14D
0005433985130	4135	35	14E
0005433985150	4135	36	17A
0005433985132	4135	37	17D
0005433985151	4135	38	17E
0005433985157	4135	39	18F
0005433985135	4135	40	19A
0005433985142	4135	41	19E
0005433985128	4135	42	19F
0005433985149	4135	43	20D
0005433985138	4135	44	20E
0005433168301	21332	1	3B
0005433168299	21332	2	3D
0005433168302	21332	3	6C
0005433168300	21332	4	20A
0005432869415	17856	1	3F
0005432869416	17856	2	8F
0005432869413	17856	3	9A
0005434151654	17856	4	12D
0005434151656	17856	5	18E
0005432869412	17856	6	19D
0005434151655	17856	7	20C
0005432869414	17856	8	20F
0005432327913	3108	1	1D
0005432327892	3108	2	2D
0005432327911	3108	3	2F
0005432327914	3108	4	3F
0005432287105	3108	5	4D
0005432287101	3108	6	4F
0005432287104	3108	7	4E
0005432327915	3108	8	5C
0005432327904	3108	9	5E
0005432327907	3108	10	5F
0005432327925	3108	11	6A
0005432327930	3108	12	6C
0005432327894	3108	13	6D
0005432287100	3108	14	6E
0005433438767	3108	15	6F
0005432327931	3108	16	7A
0005432327923	3108	17	7C
0005432327898	3108	18	7D
0005432327920	3108	19	7E
0005432327928	3108	20	8A
0005432327893	3108	21	8C
0005432327921	3108	22	8E
0005432327934	3108	23	8F
0005432327912	3108	24	9A
0005432327901	3108	25	9C
0005432327929	3108	26	9F
0005432327932	3108	27	10A
0005432287099	3108	28	10C
0005432327924	3108	29	10D
0005432327903	3108	30	10F
0005433438765	3108	31	11C
0005432327890	3108	32	11E
0005432327896	3108	33	11F
0005433438764	3108	34	12A
0005433438763	3108	35	12C
0005432327917	3108	36	12D
0005432327906	3108	37	13A
0005432327910	3108	38	13C
0005432287103	3108	39	13D
0005432327919	3108	40	13E
0005432327895	3108	41	13F
0005432327926	3108	42	14C
0005432327899	3108	43	14D
0005432327902	3108	44	14E
0005432327897	3108	45	15A
0005432327909	3108	46	15C
0005432287102	3108	47	16D
0005433438766	3108	48	17A
0005432327937	3108	49	17C
0005432327891	3108	50	17E
0005432327922	3108	51	17F
0005432327905	3108	52	18C
0005432327935	3108	53	18D
0005432327900	3108	54	18F
0005432327927	3108	55	19A
0005432327936	3108	56	19C
0005432327918	3108	57	19D
0005432327908	3108	58	20A
0005432327916	3108	59	20D
0005432327933	3108	60	20F
0005432905025	31103	1	3F
0005432054254	31103	2	4C
0005432905022	31103	3	7E
0005432905024	31103	4	11E
0005432905023	31103	5	12E
0005432054252	31103	6	13C
0005432905019	31103	7	13F
0005432905020	31103	8	14D
0005432905021	31103	9	15C
0005432054253	31103	10	19C
0005434309500	6223	1	1A
0005434309510	6223	2	1D
0005432146164	6223	3	2D
0005434309502	6223	4	3F
0005435998953	6223	5	5C
0005435998957	6223	6	5E
0005434309511	6223	7	6C
0005435998963	6223	8	6E
0005434309508	6223	9	7A
0005434309506	6223	10	7C
0005435998956	6223	11	8C
0005435998965	6223	12	9E
0005434309509	6223	13	10B
0005435998964	6223	14	11E
0005435998952	6223	15	11F
0005435998959	6223	16	12F
0005434309501	6223	17	13E
0005435998962	6223	18	14A
0005434309513	6223	19	14C
0005434309512	6223	20	14D
0005435998958	6223	21	16A
0005435998954	6223	22	17C
0005432146163	6223	23	18A
0005435998966	6223	24	18C
0005435998961	6223	25	18E
0005434309505	6223	26	18F
0005435998960	6223	27	19A
0005434309507	6223	28	19E
0005434309503	6223	29	19F
0005435998967	6223	30	20A
0005434309504	6223	31	20E
0005432146165	6223	32	21B
0005435998955	6223	33	23A
0005435998951	6223	34	23E
0005435296942	19528	1	1D
0005435296939	19528	2	2F
0005435296941	19528	3	7A
0005435296938	19528	4	7D
0005435296943	19528	5	7F
0005435296940	19528	6	16E
0005433158094	17534	1	21B
0005433158093	17534	2	22B
0005435501945	1567	1	1A
0005435508176	1567	2	1C
0005435501931	1567	3	1F
0005434565681	1567	4	2C
0005435501933	1567	5	2D
0005434565690	1567	6	3C
0005435517599	1567	7	3D
0005435508167	1567	8	3F
0005435501932	1567	9	4A
0005435501936	1567	10	4C
0005435501950	1567	11	4D
0005434565688	1567	12	5A
0005435517590	1567	13	5D
0005435517605	1567	14	5F
0005435508174	1567	15	6C
0005435501947	1567	16	6D
0005432291890	1567	17	6E
0005435508166	1567	18	6F
0005435501941	1567	19	7A
0005434565686	1567	20	7C
0005435517602	1567	21	7D
0005435517591	1567	22	7E
0005434565678	1567	23	7F
0005435517595	1567	24	8A
0005435501937	1567	25	8D
0005435508164	1567	26	8E
0005434565684	1567	27	8F
0005435501943	1567	28	9A
0005434565687	1567	29	9E
0005435517604	1567	30	9F
0005435501948	1567	31	10A
0005435517596	1567	32	10D
0005435501946	1567	33	10E
0005435517603	1567	34	11A
0005432291889	1567	35	11C
0005435517594	1567	36	11D
0005435508173	1567	37	11E
0005435501944	1567	38	11F
0005434565679	1567	39	12A
0005435508171	1567	40	12C
0005435517600	1567	41	12D
0005434565682	1567	42	12E
0005435508170	1567	43	13A
0005435501952	1567	44	13C
0005435501935	1567	45	13D
0005435508165	1567	46	13E
0005435501938	1567	47	13F
0005435508175	1567	48	14A
0005434565689	1567	49	14C
0005435517585	1567	50	14D
0005435517601	1567	51	14E
0005435517587	1567	52	15A
0005435501949	1567	53	14F
0005435517598	1567	54	15C
0005434565691	1567	55	15D
0005435517589	1567	56	15E
0005435508168	1567	57	15F
0005435517588	1567	58	16C
0005435501940	1567	59	16F
0005435501951	1567	60	17A
0005434565677	1567	61	17C
0005434565685	1567	62	17E
0005435517592	1567	63	18A
0005435501942	1567	64	18C
0005434565683	1567	65	18D
0005435517597	1567	66	18E
0005435501934	1567	67	18F
0005435508169	1567	68	19C
0005435517593	1567	69	19D
0005435517586	1567	70	19F
0005435501939	1567	71	20A
0005435517606	1567	72	20D
0005434565680	1567	73	20E
0005435508172	1567	74	20F
0005433185971	20846	1	2A
0005433185974	20846	2	3A
0005433185975	20846	3	4D
0005433185970	20846	4	5C
0005433185968	20846	5	6F
0005433185969	20846	6	7E
0005433185973	20846	7	18C
0005433185972	20846	8	20F
0005435153627	3925	1	1B
0005435153628	3925	2	2D
0005435153626	3925	3	3B
0005435153631	3925	4	7C
0005435153629	3925	5	18D
0005435153630	3925	6	20D
0005435931536	21848	1	6C
0005435931538	21848	2	18C
0005435931537	21848	3	22D
0005432628586	7226	1	1A
0005432628591	7226	2	2D
0005432628592	7226	3	3D
0005432628588	7226	4	4B
0005432628593	7226	5	4D
0005432628595	7226	6	5C
0005432628596	7226	7	5D
0005432628597	7226	8	6A
0005432628599	7226	9	18A
0005432628594	7226	10	19A
0005432628589	7226	11	20A
0005432628590	7226	12	20C
0005432628585	7226	13	21A
0005432628598	7226	14	21B
0005432628587	7226	15	22C
0005435225447	28100	1	2A
0005435225445	28100	2	18D
0005435225446	28100	3	19A
0005435225449	28100	4	20D
0005435225444	28100	5	21A
0005435225443	28100	6	22A
0005435225448	28100	7	22B
0005435959984	8719	1	6C
0005435959983	8719	2	7C
0005435959985	8719	3	18A
0005435959982	8719	4	20A
0005434267884	15264	1	2A
0005434267885	15264	2	3B
0005434267886	15264	3	5A
0005432674869	1214	1	2A
0005432674874	1214	2	2F
0005432674868	1214	3	3C
0005432674866	1214	4	3F
0005432674876	1214	5	4C
0005432674865	1214	6	5A
0005432674875	1214	7	7D
0005432674873	1214	8	8C
0005432674872	1214	9	10A
0005432674867	1214	10	14F
0005432674871	1214	11	17E
0005432674863	1214	12	18F
0005432674870	1214	13	19B
0005432674877	1214	14	19F
0005432674864	1214	15	20B
0005432873167	17509	1	3D
0005432873168	17509	2	3C
0005432873172	17509	3	5A
0005432873165	17509	4	7A
0005432873171	17509	5	7F
0005432873166	17509	6	10D
0005432873173	17509	7	14C
0005432873169	17509	8	17C
0005432873170	17509	9	20D
0005434434912	1127	1	2A
0005434434913	1127	2	2B
0005434434915	1127	3	3C
0005434434918	1127	4	3D
0005434434919	1127	5	4C
0005434434922	1127	6	5B
0005434434924	1127	7	5C
0005434434910	1127	8	7B
0005434434914	1127	9	18B
0005434434909	1127	10	19C
0005434434921	1127	11	19D
0005434434911	1127	12	20D
0005434434920	1127	13	21B
0005434434916	1127	14	21C
0005434434917	1127	15	22A
0005434434923	1127	16	22D
0005433156598	17301	1	1C
0005433156599	17301	2	2B
0005433156605	17301	3	3D
0005433156604	17301	4	4A
0005433156597	17301	5	4C
0005433156603	17301	6	20A
0005433156600	17301	7	21D
0005433156602	17301	8	22C
0005433156601	17301	9	22D
0005435086706	4103	1	2D
0005435086702	4103	2	3A
0005435086704	4103	3	5A
0005435086703	4103	4	19D
0005435086701	4103	5	21C
0005435086705	4103	6	22B
0005435086700	4103	7	22D
0005435928060	24384	1	1B
0005435928061	24384	2	2D
0005435928057	24384	3	3A
0005435928059	24384	4	7B
0005435928058	24384	5	19A
0005435551493	17003	1	3F
0005435551492	17003	2	4A
0005435551491	17003	3	4G
0005435098522	17003	4	13F
0005435098521	17003	5	14H
0005435551490	17003	6	20F
0005434625797	4822	1	4D
0005434625796	4822	2	6D
0005434625798	4822	3	8A
0005434625793	4822	4	10E
0005434625802	4822	5	11D
0005434625799	4822	6	12F
0005434625794	4822	7	14F
0005434625801	4822	8	19A
0005434625795	4822	9	19F
0005434625800	4822	10	20C
0005435907416	32920	1	1D
0005435907418	32920	2	5F
0005433194818	32920	3	9E
0005435907417	32920	4	11A
0005433194819	32920	5	11F
0005435907419	32920	6	13E
0005435907420	32920	7	15F
0005433194817	32920	8	19F
0005432195657	13777	1	2D
0005432195655	13777	2	3C
0005435937312	13777	3	5A
0005435937307	13777	4	5D
0005435937313	13777	5	18B
0005435937310	13777	6	18D
0005435937306	13777	7	19A
0005432195656	13777	8	19B
0005435937308	13777	9	19D
0005435937309	13777	10	20A
0005435937305	13777	11	21A
0005435937311	13777	12	22A
0005435310836	20272	1	1F
0005435310855	20272	2	2A
0005435310841	20272	3	2C
0005435310846	20272	4	3C
0005435310848	20272	5	3D
0005435310840	20272	6	4F
0005435310854	20272	7	6D
0005432058315	20272	8	7E
0005435310851	20272	9	8D
0005435310849	20272	10	9A
0005435310847	20272	11	9C
0005432058313	20272	12	11F
0005435310844	20272	13	12E
0005435310842	20272	14	14D
0005435310839	20272	15	14F
0005435310845	20272	16	15E
0005435310852	20272	17	15F
0005435310838	20272	18	16D
0005435310837	20272	19	16F
0005435310853	20272	20	17E
0005435310843	20272	21	17F
0005435310850	20272	22	18F
0005432058314	20272	23	19A
0005432058312	20272	24	20F
0005434406641	26958	1	1A
0005432153814	26958	2	1C
0005434406650	26958	3	1D
0005434406669	26958	4	2C
0005434406689	26958	5	2D
0005434406685	26958	6	2F
0005434406643	26958	7	3A
0005434406668	26958	8	3C
0005434406665	26958	9	3D
0005434406695	26958	10	3F
0005432153813	26958	11	4C
0005434406651	26958	12	4E
0005434406654	26958	13	4F
0005434406642	26958	14	5A
0005434406683	26958	15	5C
0005432153815	26958	16	5D
0005434406649	26958	17	5E
0005434406646	26958	18	6A
0005434406701	26958	19	6C
0005432153817	26958	20	6F
0005434406678	26958	21	7A
0005434406690	26958	22	7D
0005434406667	26958	23	7E
0005434406658	26958	24	7F
0005434406679	26958	25	8A
0005434406674	26958	26	8C
0005434406639	26958	27	8F
0005434406673	26958	28	9A
0005434406691	26958	29	9C
0005434406700	26958	30	9E
0005434406656	26958	31	10A
0005434406692	26958	32	10F
0005434406681	26958	33	11A
0005434406666	26958	34	11C
0005434406640	26958	35	11D
0005434406682	26958	36	11E
0005434406670	26958	37	11F
0005434406661	26958	38	12C
0005434406698	26958	39	12D
0005434406662	26958	40	12E
0005434406676	26958	41	12F
0005434406696	26958	42	13A
0005434406653	26958	43	13D
0005434406652	26958	44	13E
0005434406687	26958	45	14D
0005434406677	26958	46	14F
0005434406645	26958	47	15C
0005434406680	26958	48	15D
0005434406693	26958	49	15E
0005434406644	26958	50	15F
0005432153819	26958	51	16A
0005434406659	26958	52	16C
0005434406664	26958	53	16D
0005434406660	26958	54	16E
0005434406655	26958	55	16F
0005434406657	26958	56	17A
0005434406699	26958	57	17C
0005434406671	26958	58	17D
0005434406675	26958	59	17F
0005434406647	26958	60	18C
0005434406686	26958	61	18D
0005434406684	26958	62	18E
0005434406663	26958	63	18F
0005434406697	26958	64	19A
0005434406648	26958	65	19C
0005432153818	26958	66	19D
0005434406672	26958	67	20C
0005432153816	26958	68	20D
0005434406694	26958	69	20E
0005434406688	26958	70	20F
0005434319150	5671	1	2D
0005434319142	5671	2	4F
0005434319149	5671	3	6F
0005434311182	5671	4	7F
0005432109655	5671	5	8D
0005432109656	5671	6	10E
0005434319144	5671	7	10F
0005434319148	5671	8	11F
0005434319143	5671	9	12C
0005434319141	5671	10	13E
0005434319147	5671	11	14F
0005434319145	5671	12	16D
0005434311181	5671	13	16E
0005434319146	5671	14	18E
0005433123577	15695	1	2C
0005433123582	15695	2	2F
0005433123571	15695	3	4A
0005433123580	15695	4	4C
0005433123578	15695	5	6C
0005433123566	15695	6	7C
0005433123573	15695	7	8C
0005433123574	15695	8	11C
0005433123586	15695	9	11D
0005433123587	15695	10	11E
0005433123569	15695	11	12C
0005433123568	15695	12	12D
0005433123575	15695	13	13A
0005433123584	15695	14	13F
0005433123567	15695	15	14A
0005433123565	15695	16	15A
0005433123570	15695	17	15C
0005433123585	15695	18	15E
0005433123583	15695	19	16A
0005433123579	15695	20	17F
0005433123572	15695	21	18F
0005433123581	15695	22	20E
0005433123576	15695	23	20F
0005435219165	31748	1	3C
0005435220283	31748	2	21D
0005435220284	31748	3	22D
0005434484235	9001	1	2B
0005434484231	9001	2	4B
0005434484237	9001	3	4D
0005434484234	9001	4	6B
0005434484236	9001	5	6C
0005434484232	9001	6	18B
0005434484233	9001	7	21B
0005434189075	16620	1	4B
0005434189079	16620	2	6A
0005434189076	16620	3	20C
0005434189077	16620	4	20D
0005434189078	16620	5	21A
0005434189080	16620	6	22B
0005433123582	7571	1	1C
0005433123572	7571	2	2F
0005433123565	7571	3	3C
0005433123574	7571	4	4A
0005433123570	7571	5	4C
0005433123583	7571	6	4F
0005433123581	7571	7	5F
0005433123573	7571	8	7F
0005433123580	7571	9	8D
0005433123566	7571	10	10C
0005433123576	7571	11	11E
0005433123567	7571	12	13D
0005433123584	7571	13	14D
0005433123586	7571	14	15D
0005433123587	7571	15	16A
0005433123579	7571	16	17A
0005433123585	7571	17	17D
0005433123578	7571	18	17F
0005433123577	7571	19	19C
0005433123575	7571	20	19E
0005433123569	7571	21	19F
0005433123568	7571	22	20A
0005433123571	7571	23	20D
0005432720450	7572	1	1C
0005432692555	7572	2	1D
0005432692532	7572	3	1F
0005432720453	7572	4	2A
0005432720446	7572	5	2C
0005432692535	7572	6	2F
0005432720452	7572	7	3D
0005433449584	7572	8	3F
0005432720442	7572	9	4A
0005432720448	7572	10	4C
0005432720447	7572	11	4D
0005432720455	7572	12	4E
0005433449583	7572	13	4F
0005432720435	7572	14	5A
0005432692528	7572	15	5C
0005432692539	7572	16	5D
0005432720433	7572	17	5E
0005432692547	7572	18	5F
0005432720444	7572	19	6A
0005432692527	7572	20	6C
0005433449590	7572	21	6D
0005432692536	7572	22	6E
0005433449604	7572	23	6F
0005432720445	7572	24	7A
0005432692552	7572	25	7C
0005432692542	7572	26	7D
0005432692545	7572	27	7E
0005432720440	7572	28	7F
0005433449595	7572	29	8A
0005432720429	7572	30	8C
0005432720454	7572	31	8D
0005432692534	7572	32	8E
0005432692529	7572	33	8F
0005432692541	7572	34	9A
0005432071520	7572	35	9C
0005432720451	7572	36	9D
0005433449588	7572	37	9E
0005433449601	7572	38	9F
0005432720430	7572	39	10A
0005432720437	7572	40	10C
0005432720439	7572	41	10D
0005432071522	7572	42	10F
0005433449593	7572	43	11A
0005433449586	7572	44	11C
0005432692543	7572	45	11D
0005432720436	7572	46	11E
0005432720449	7572	47	11F
0005432720434	7572	48	12A
0005433449592	7572	49	12C
0005432692549	7572	50	12D
0005432692557	7572	51	12E
0005433449599	7572	52	13A
0005433449591	7572	53	13C
0005432692553	7572	54	13D
0005432720443	7572	55	13E
0005432071521	7572	56	13F
0005432720428	7572	57	14A
0005432692537	7572	58	14C
0005432720438	7572	59	14E
0005432692551	7572	60	15D
0005432692540	7572	61	15C
0005433449597	7572	62	15E
0005432692546	7572	63	15F
0005432692530	7572	64	16A
0005432692554	7572	65	16C
0005432692550	7572	66	16D
0005433449598	7572	67	16E
0005432720432	7572	68	16F
0005432692533	7572	69	17A
0005432692548	7572	70	17C
0005432692531	7572	71	17D
0005433449603	7572	72	17E
0005432692556	7572	73	17F
0005433449600	7572	74	18A
0005433449587	7572	75	18C
0005432692558	7572	76	18D
0005433449602	7572	77	18F
0005433449596	7572	78	18E
0005433449589	7572	79	19A
0005433449605	7572	80	19C
0005433449594	7572	81	19D
0005432692544	7572	82	19E
0005432720441	7572	83	20A
0005432720431	7572	84	20C
0005433449585	7572	85	20E
0005432692538	7572	86	20F
0005433722106	30450	1	2C
0005433722105	30450	2	4E
0005433722104	30450	3	9D
0005433722102	30450	4	12E
0005433722103	30450	5	15F
0005434586172	1368	1	1A
0005434513533	1368	2	1C
0005434586169	1368	3	2A
0005434586179	1368	4	2D
0005434586161	1368	5	2F
0005433524846	1368	6	3A
0005434514921	1368	7	3C
0005433524850	1368	8	3F
0005432270954	1368	9	4C
0005434586160	1368	10	4D
0005433524855	1368	11	4E
0005434586164	1368	12	5A
0005434586171	1368	13	5E
0005432270955	1368	14	6A
0005434586165	1368	15	6F
0005434586162	1368	16	7A
0005434586158	1368	17	7C
0005433524853	1368	18	7D
0005434586177	1368	19	7E
0005434586176	1368	20	7F
0005434586163	1368	21	8D
0005433524851	1368	22	9F
0005432270956	1368	23	10D
0005433524852	1368	24	10E
0005434586181	1368	25	11A
0005434586159	1368	26	11E
0005433524854	1368	27	11F
0005433724726	1368	28	12A
0005433524849	1368	29	12C
0005434586173	1368	30	12E
0005433724727	1368	31	13A
0005434586174	1368	32	13D
0005434513534	1368	33	14C
0005434586182	1368	34	14F
0005434586180	1368	35	15A
0005433724724	1368	36	15D
0005434586157	1368	37	16C
0005434514922	1368	38	16D
0005434586170	1368	39	16E
0005434586167	1368	40	16F
0005434586166	1368	41	17C
0005434586168	1368	42	17D
0005433724725	1368	43	17E
0005434513535	1368	44	18C
0005434586178	1368	45	19C
0005433524848	1368	46	19F
0005434586175	1368	47	20C
0005433524847	1368	48	20D
0005434514923	1368	49	20E
0005433192815	18514	1	4A
0005433192818	18514	2	7D
0005433192812	18514	3	9E
0005433192814	18514	4	9F
0005433192813	18514	5	10A
0005433192816	18514	6	10C
0005433192817	18514	7	11C
0005433192809	18514	8	12E
0005433192810	18514	9	18D
0005433192821	18514	10	19A
0005433192811	18514	11	19D
0005433192820	18514	12	20C
0005433192819	18514	13	20E
0005434142542	11429	1	5A
0005434142541	11429	2	7D
0005434142540	11429	3	20D
0005434142543	11429	4	21B
0005435304095	29766	1	7C
0005435304096	29766	2	7D
0005435304092	29766	3	18D
0005435304094	29766	4	19C
0005435304093	29766	5	20A
0005435304989	29766	6	23A
0005435824155	1287	1	1F
0005435824160	1287	2	2C
0005435824158	1287	3	4A
0005435824164	1287	4	5C
0005435824154	1287	5	6E
0005435824172	1287	6	7B
0005435824173	1287	7	6F
0005435824151	1287	8	8B
0005435824161	1287	9	8A
0005435824169	1287	10	8E
0005435824177	1287	11	9F
0005435824178	1287	12	9E
0005435824156	1287	13	10B
0005435824175	1287	14	10D
0005432284506	1287	15	11A
0005435824170	1287	16	11B
0005435824167	1287	17	12C
0005435824171	1287	18	12E
0005435824162	1287	19	13A
0005435824174	1287	20	13F
0005435824163	1287	21	14C
0005432284505	1287	22	16A
0005435824157	1287	23	16C
0005435824153	1287	24	16D
0005435824165	1287	25	16E
0005432284508	1287	26	17B
0005435824168	1287	27	18D
0005432284507	1287	28	19B
0005435824166	1287	29	19D
0005435824176	1287	30	20A
0005435824159	1287	31	19E
0005435824152	1287	32	20B
0005433415388	17980	1	4A
0005433415381	17980	2	5C
0005433415385	17980	3	6F
0005433415389	17980	4	7B
0005433415384	17980	5	9D
0005433415391	17980	6	9C
0005433415380	17980	7	12E
0005433415383	17980	8	13A
0005433415390	17980	9	14E
0005433415378	17980	10	15B
0005433415379	17980	11	16D
0005433415386	17980	12	17A
0005433415392	17980	13	18A
0005433415382	17980	14	18C
0005433415393	17980	15	20E
0005433415387	17980	16	21A
0005432143931	5615	1	1A
0005432782863	5615	2	1D
0005432782838	5615	3	1F
0005432782841	5615	4	2A
0005432782840	5615	5	2F
0005432782847	5615	6	3A
0005432782887	5615	7	3C
0005432782888	5615	8	4C
0005432782870	5615	9	4D
0005432782872	5615	10	4E
0005432143932	5615	11	5A
0005432782850	5615	12	5C
0005432782849	5615	13	5F
0005432782889	5615	14	6A
0005432782871	5615	15	6C
0005432782857	5615	16	6D
0005432782873	5615	17	7A
0005432782877	5615	18	7C
0005432782858	5615	19	7D
0005432782854	5615	20	7F
0005432782892	5615	21	8D
0005432782864	5615	22	8F
0005432782851	5615	23	9A
0005432782848	5615	24	9D
0005432782891	5615	25	9E
0005432782860	5615	26	9F
0005432782861	5615	27	10A
0005432782880	5615	28	10C
0005432782882	5615	29	10E
0005432782853	5615	30	10F
0005432782839	5615	31	11E
0005432782881	5615	32	11F
0005432782883	5615	33	12A
0005432782842	5615	34	12C
0005432782879	5615	35	12D
0005432782876	5615	36	12E
0005432782869	5615	37	13A
0005432782859	5615	38	13C
0005432782867	5615	39	13D
0005432782855	5615	40	14A
0005432782845	5615	41	14E
0005432782884	5615	42	15C
0005432782886	5615	43	16A
0005432782874	5615	44	16E
0005432782846	5615	45	17C
0005432143930	5615	46	17F
0005432782878	5615	47	18A
0005432782843	5615	48	18C
0005432143929	5615	49	18F
0005432782865	5615	50	19A
0005432782890	5615	51	19C
0005432782856	5615	52	19D
0005432782875	5615	53	19E
0005432782862	5615	54	19F
0005432782868	5615	55	20A
0005432782885	5615	56	20C
0005432782852	5615	57	20D
0005432782844	5615	58	20E
0005432782866	5615	59	20F
0005435476637	15345	1	1C
0005435476646	15345	2	4C
0005435476647	15345	3	4D
0005435476640	15345	4	5A
0005435476634	15345	5	5D
0005435476636	15345	6	6F
0005435476643	15345	7	8A
0005435476645	15345	8	12F
0005435476635	15345	9	14A
0005435476641	15345	10	14E
0005435476639	15345	11	15C
0005435476642	15345	12	16F
0005435476638	15345	13	18D
0005435476648	15345	14	20A
0005435476644	15345	15	20F
0005432848055	4384	1	1B
0005432848056	4384	2	2C
0005434462753	4384	3	2D
0005432848057	4384	4	3C
0005432848064	4384	5	3D
0005432848059	4384	6	4B
0005432848066	4384	7	5A
0005432848062	4384	8	5D
0005432848067	4384	9	7C
0005434463892	4384	10	7D
0005434463891	4384	11	18D
0005432848060	4384	12	19C
0005432848061	4384	13	20C
0005432848070	4384	14	21A
0005432848068	4384	15	21C
0005432848058	4384	16	22A
0005432848065	4384	17	22B
0005434462752	4384	18	22C
0005432848069	4384	19	23A
0005432848063	4384	20	23B
0005435850752	28883	1	1B
0005435850751	28883	2	2C
0005435850756	28883	3	4D
0005435850750	28883	4	5B
0005435850754	28883	5	18C
0005435850755	28883	6	19A
0005435850753	28883	7	21C
0005435850757	28883	8	22B
0005433496438	6253	1	1A
0005433496444	6253	2	1D
0005433496449	6253	3	1F
0005434443432	6253	4	2A
0005434925249	6253	5	2C
0005433496435	6253	6	2F
0005433496432	6253	7	3C
0005434443436	6253	8	3F
0005433496431	6253	9	4A
0005434925247	6253	10	4C
0005434925256	6253	11	4E
0005434925264	6253	12	4D
0005434443433	6253	13	5C
0005434925254	6253	14	5D
0005434443427	6253	15	5E
0005434925265	6253	16	5F
0005434443424	6253	17	6D
0005433496436	6253	18	6E
0005434925250	6253	19	6F
0005434925263	6253	20	7C
0005434925269	6253	21	7D
0005434925255	6253	22	7F
0005433496430	6253	23	7E
0005434925266	6253	24	8D
0005433496418	6253	25	8E
0005434443434	6253	26	8F
0005432075169	6253	27	9A
0005433496447	6253	28	9C
0005434443438	6253	29	9D
0005433496433	6253	30	9F
0005434925270	6253	31	10C
0005433496420	6253	32	10E
0005434925258	6253	33	10F
0005433496445	6253	34	11A
0005434925248	6253	35	11C
0005433496422	6253	36	11D
0005434443439	6253	37	11F
0005434925268	6253	38	12A
0005433496421	6253	39	12C
0005434925251	6253	40	12D
0005434925271	6253	41	12E
0005433496428	6253	42	12F
0005433496425	6253	43	13A
0005433496434	6253	44	13C
0005434925253	6253	45	13D
0005434925260	6253	46	13E
0005433496429	6253	47	13F
0005433496427	6253	48	14A
0005432075170	6253	49	14C
0005434443425	6253	50	14D
0005433496424	6253	51	14E
0005434443435	6253	52	14F
0005434925259	6253	53	15A
0005433496423	6253	54	15C
0005434443429	6253	55	15D
0005434443428	6253	56	16D
0005434443426	6253	57	16E
0005433496442	6253	58	16F
0005433496441	6253	59	17A
0005434443431	6253	60	17C
0005434925261	6253	61	17D
0005434925257	6253	62	17E
0005433496440	6253	63	17F
0005433496446	6253	64	18A
0005433496426	6253	65	18D
0005432075171	6253	66	18E
0005433496437	6253	67	18F
0005434925272	6253	68	19A
0005434925252	6253	69	19C
0005433496439	6253	70	19D
0005433496419	6253	71	19E
0005434925262	6253	72	19F
0005434443437	6253	73	20A
0005433496443	6253	74	20C
0005434925267	6253	75	20D
0005433496448	6253	76	20E
0005434443430	6253	77	20F
0005435242399	12211	1	1A
0005435242390	12211	2	3C
0005435242389	12211	3	3D
0005435242409	12211	4	3F
0005435242393	12211	5	5C
0005435242400	12211	6	5D
0005435242403	12211	7	7C
0005435242404	12211	8	7F
0005435242394	12211	9	9C
0005435242401	12211	10	9D
0005435242414	12211	11	9E
0005435242413	12211	12	9F
0005435242396	12211	13	11C
0005435242410	12211	14	11E
0005435242411	12211	15	11F
0005435242398	12211	16	12A
0005435242407	12211	17	13A
0005435242391	12211	18	13C
0005435242395	12211	19	14F
0005435242388	12211	20	15A
0005435242408	12211	21	15C
0005435242392	12211	22	15E
0005435242405	12211	23	16C
0005435242402	12211	24	16D
0005435242412	12211	25	16E
0005435242406	12211	26	17A
0005435242387	12211	27	17C
0005435242415	12211	28	19C
0005435242397	12211	29	20C
0005435913849	10095	1	5D
0005434910069	10095	2	6E
0005434910068	10095	3	15C
0005434910070	10095	4	16D
0005435913850	10095	5	18D
0005434876590	14602	1	1C
0005434876598	14602	2	1A
0005434876624	14602	3	1D
0005434876582	14602	4	2C
0005434876616	14602	5	2A
0005434876615	14602	6	2D
0005434876569	14602	7	3A
0005434876638	14602	8	3D
0005434876620	14602	9	3C
0005434876608	14602	10	4A
0005434876636	14602	11	3F
0005434876555	14602	12	4D
0005434876601	14602	13	4C
0005434876617	14602	14	4F
0005434876593	14602	15	5C
0005434876610	14602	16	5F
0005434876564	14602	17	5D
0005434876629	14602	18	6A
0005434876650	14602	19	6C
0005434876648	14602	20	6F
0005434876621	14602	21	6E
0005434876574	14602	22	6D
0005434876618	14602	23	7A
0005434876641	14602	24	7C
0005434876579	14602	25	7B
0005434876565	14602	26	7D
0005434876635	14602	27	7F
0005434758853	14602	28	7E
0005434876557	14602	29	8B
0005434876600	14602	30	8D
0005434876558	14602	31	8C
0005434876611	14602	32	8F
0005434876563	14602	33	9B
0005434876570	14602	34	9A
0005434876637	14602	35	9C
0005434876583	14602	36	9E
0005434876639	14602	37	9D
0005434876573	14602	38	10B
0005434876612	14602	39	10A
0005434876595	14602	40	9F
0005434876626	14602	41	10C
0005434876592	14602	42	10E
0005434876580	14602	43	10D
0005434876560	14602	44	11A
0005434876586	14602	45	10F
0005434876568	14602	46	11C
0005434876581	14602	47	11B
0005434876619	14602	48	11F
0005434876607	14602	49	11E
0005434876609	14602	50	12B
0005434876559	14602	51	12A
0005434876614	14602	52	12D
0005434876603	14602	53	12C
0005434876651	14602	54	12E
0005434758854	14602	55	13A
0005434876649	14602	56	12F
0005434876633	14602	57	13C
0005434758852	14602	58	13B
0005434876606	14602	59	13E
0005434876562	14602	60	13D
0005434876646	14602	61	13F
0005434876596	14602	62	14B
0005434876561	14602	63	14D
0005434876556	14602	64	14C
0005434876634	14602	65	14F
0005434876631	14602	66	15B
0005434876640	14602	67	15A
0005434876625	14602	68	15C
0005434876623	14602	69	15F
0005434876627	14602	70	15E
0005434876575	14602	71	16A
0005434876597	14602	72	16C
0005434876588	14602	73	16B
0005434876642	14602	74	16F
0005434876572	14602	75	16E
0005434876587	14602	76	17C
0005434876585	14602	77	17B
0005434876605	14602	78	17F
0005434876602	14602	79	17E
0005434876628	14602	80	18B
0005434876589	14602	81	18A
0005434876567	14602	82	18C
0005434876599	14602	83	18D
0005434876647	14602	84	19A
0005434876645	14602	85	18F
0005434876644	14602	86	19B
0005434876591	14602	87	19E
0005434876576	14602	88	19D
0005434876632	14602	89	20B
0005434876604	14602	90	20A
0005434876566	14602	91	20D
0005434876578	14602	92	20C
0005434876594	14602	93	20F
0005434876622	14602	94	20E
0005434876584	14602	95	21A
0005434876571	14602	96	21C
0005434876643	14602	97	21B
0005434876577	14602	98	21E
0005434876630	14602	99	21D
0005434876613	14602	100	21F
0005435659943	9262	1	1A
0005435659937	9262	2	1B
0005435659948	9262	3	1C
0005435659946	9262	4	3A
0005435659939	9262	5	4C
0005435659941	9262	6	4D
0005435659940	9262	7	5A
0005435659944	9262	8	5D
0005435659938	9262	9	20A
0005435659945	9262	10	21C
0005435659947	9262	11	21D
0005435659942	9262	12	22A
0005434251798	24676	1	1D
0005434251800	24676	2	2A
0005434251802	24676	3	2B
0005434251795	24676	4	4C
0005434251801	24676	5	5B
0005434251797	24676	6	5C
0005434251804	24676	7	6B
0005434251803	24676	8	6C
0005434251796	24676	9	7A
0005434251799	24676	10	18B
0005433679726	2796	1	1A
0005433679724	2796	2	1C
0005433679740	2796	3	1D
0005433679728	2796	4	1F
0005433679715	2796	5	2A
0005432222688	2796	6	2D
0005433679754	2796	7	3C
0005432222690	2796	8	4A
0005433679717	2796	9	4C
0005433679752	2796	10	4D
0005433679718	2796	11	4E
0005433679716	2796	12	5C
0005433679745	2796	13	5D
0005433679731	2796	14	5E
0005433679727	2796	15	6A
0005433679747	2796	16	6C
0005433679719	2796	17	6D
0005433679755	2796	18	6E
0005433679734	2796	19	7A
0005433679710	2796	20	7E
0005433679733	2796	21	7F
0005433679722	2796	22	8C
0005433679744	2796	23	8E
0005433679739	2796	24	8F
0005433679732	2796	25	10A
0005433679729	2796	26	10C
0005433679713	2796	27	10E
0005433679711	2796	28	11A
0005433679720	2796	29	12C
0005433679736	2796	30	12D
0005433679750	2796	31	12E
0005433679748	2796	32	12F
0005432222691	2796	33	13A
0005433679741	2796	34	13D
0005433679742	2796	35	13E
0005433679749	2796	36	13F
0005432222689	2796	37	14A
0005433679709	2796	38	14C
0005433679725	2796	39	14D
0005433679721	2796	40	14F
0005433679756	2796	41	15A
0005433679751	2796	42	15D
0005433679723	2796	43	16C
0005433679737	2796	44	16F
0005433679746	2796	45	17A
0005433679743	2796	46	17C
0005433679730	2796	47	17F
0005433679735	2796	48	18A
0005433679738	2796	49	18C
0005433679753	2796	50	18F
0005433679712	2796	51	19C
0005433679714	2796	52	19D
0005432222692	2796	53	20C
0005432966502	29150	1	2C
0005432966499	29150	2	3A
0005432966486	29150	3	3C
0005432966482	29150	4	3F
0005432966494	29150	5	4A
0005432966495	29150	6	4C
0005432966489	29150	7	4D
0005432966504	29150	8	5C
0005432966492	29150	9	6C
0005432966480	29150	10	6D
0005432966497	29150	11	7F
0005432005165	29150	12	8A
0005432966483	29150	13	8F
0005432005164	29150	14	9A
0005432966503	29150	15	10C
0005432966498	29150	16	11A
0005432966491	29150	17	13C
0005432966493	29150	18	13E
0005432966479	29150	19	13F
0005432966481	29150	20	14E
0005432966496	29150	21	14F
0005432966488	29150	22	15C
0005432966500	29150	23	16A
0005432966484	29150	24	16C
0005432966501	29150	25	16E
0005432005163	29150	26	17C
0005432966487	29150	27	17E
0005432966485	29150	28	18A
0005432966490	29150	29	18D
0005433577568	9307	1	3A
0005433577564	9307	2	4C
0005433577563	9307	3	6A
0005433577565	9307	4	6F
0005432755016	9307	5	7F
0005432756789	9307	6	8A
0005433577567	9307	7	8C
0005433577572	9307	8	10B
0005433577566	9307	9	10E
0005432755017	9307	10	12B
0005433577571	9307	11	14B
0005432756787	9307	12	14F
0005433577562	9307	13	19B
0005432755015	9307	14	20B
0005433577573	9307	15	20C
0005433577570	9307	16	25B
0005433577569	9307	17	26A
0005432756788	9307	18	27A
0005433577561	9307	19	30C
0005432184902	4199	1	2C
0005435986654	4199	2	13B
0005435986650	4199	3	13G
0005435986652	4199	4	15H
0005435986649	4199	5	21E
0005432184901	4199	6	24B
0005435986653	4199	7	28A
0005432184900	4199	8	33B
0005435986651	4199	9	38E
0005435947005	26588	1	1A
0005432571260	26588	2	1H
0005432571259	26588	3	3B
0005435947001	26588	4	4A
0005435947010	26588	5	5C
0005435947004	26588	6	11G
0005435856131	26588	7	13A
0005435947003	26588	8	14A
0005435946996	26588	9	18E
0005435947000	26588	10	18D
0005435787321	26588	11	19F
0005432571257	26588	12	20E
0005435946997	26588	13	23H
0005435947009	26588	14	30F
0005432571258	26588	15	30G
0005435946998	26588	16	31G
0005435947006	26588	17	32E
0005435946999	26588	18	33F
0005435856133	26588	19	33G
0005435947008	26588	20	36B
0005435856130	26588	21	36D
0005435947002	26588	22	37H
0005435787320	26588	23	38D
0005435947011	26588	24	38F
0005435947007	26588	25	38G
0005435856132	26588	26	38H
0005433568041	331	1	2A
0005433568033	331	2	2D
0005433568034	331	3	3F
0005433568043	331	4	5A
0005433568065	331	5	4F
0005433568018	331	6	5F
0005433568045	331	7	5D
0005433568061	331	8	6A
0005433568019	331	9	7A
0005433568029	331	10	8A
0005433568037	331	11	8B
0005433568057	331	12	9B
0005433568036	331	13	9C
0005433568022	331	14	9D
0005433568038	331	15	9F
0005433568053	331	16	10B
0005432238832	331	17	10F
0005433568060	331	18	11A
0005433568040	331	19	11D
0005433568054	331	20	11C
0005432238829	331	21	11F
0005433568066	331	22	12D
0005433568067	331	23	13B
0005433568042	331	24	14C
0005433568027	331	25	15A
0005433568028	331	26	15D
0005432238831	331	27	15F
0005433568063	331	28	15E
0005432238828	331	29	17A
0005432238830	331	30	17D
0005433568032	331	31	17E
0005433568044	331	32	18A
0005433568023	331	33	18B
0005433568049	331	34	18D
0005433568046	331	35	18C
0005433568047	331	36	19E
0005433568052	331	37	20D
0005433568020	331	38	21B
0005433568039	331	39	21D
0005433568048	331	40	21F
0005433568050	331	41	22B
0005433568056	331	42	22C
0005433568030	331	43	22E
0005433568031	331	44	22D
0005433568035	331	45	23C
0005433568058	331	46	24D
0005433568059	331	47	24F
0005432238827	331	48	25B
0005433568015	331	49	25D
0005433568062	331	50	25C
0005433568025	331	51	27A
0005433568016	331	52	27C
0005433568068	331	53	27E
0005433568064	331	54	28C
0005433568055	331	55	28D
0005433568017	331	56	29A
0005433568051	331	57	29D
0005433568026	331	58	30F
0005433568024	331	59	31B
0005433568021	331	60	31F
0005433074208	11606	1	1D
0005432192264	11606	2	1C
0005433134056	11606	3	2D
0005433074209	11606	4	4D
0005433074203	11606	5	6C
0005433074216	11606	6	6F
0005433074217	11606	7	6D
0005433074213	11606	8	7A
0005433074204	11606	9	8A
0005433074219	11606	10	10B
0005432192265	11606	11	11E
0005433074214	11606	12	12E
0005433074225	11606	13	12D
0005433074199	11606	14	13A
0005433074197	11606	15	13D
0005433074207	11606	16	13F
0005433074196	11606	17	14D
0005433074211	11606	18	15A
0005433134059	11606	19	15E
0005433131627	11606	20	15D
0005433134058	11606	21	15F
0005433131629	11606	22	16A
0005433074222	11606	23	17A
0005433074218	11606	24	17F
0005433074205	11606	25	17E
0005433074210	11606	26	18C
0005433074201	11606	27	18E
0005432192263	11606	28	19E
0005433074223	11606	29	20B
0005433131626	11606	30	20F
0005433074212	11606	31	24A
0005433074200	11606	32	25A
0005433074221	11606	33	27D
0005433131628	11606	34	27F
0005433134057	11606	35	28C
0005433074206	11606	36	28F
0005433074198	11606	37	29D
0005433074224	11606	38	29F
0005433074220	11606	39	29E
0005433074215	11606	40	30A
0005433074202	11606	41	31B
0005433817405	10005	1	1A
0005433817407	10005	2	1B
0005433817406	10005	3	3B
0005433817404	10005	4	6B
0005434732921	13968	1	3B
0005434732918	13968	2	4A
0005434732920	13968	3	4B
0005434732919	13968	4	5A
0005433753223	2323	1	1A
0005432655337	2323	2	1C
0005433753243	2323	3	1B
0005432655327	2323	4	1F
0005433753278	2323	5	1G
0005433753262	2323	6	2A
0005435981535	2323	7	1H
0005435981511	2323	8	2F
0005433753275	2323	9	2C
0005433753244	2323	10	3B
0005433753246	2323	11	3F
0005433753273	2323	12	3C
0005432225946	2323	13	4A
0005435981527	2323	14	4B
0005435981514	2323	15	4F
0005435981510	2323	16	5A
0005432655334	2323	17	5F
0005433753267	2323	18	5C
0005435981519	2323	19	9B
0005433753268	2323	20	11B
0005435981537	2323	21	11F
0005432655335	2323	22	11G
0005433753249	2323	23	12A
0005435981513	2323	24	12F
0005433753269	2323	25	13D
0005435981534	2323	26	13B
0005433753258	2323	27	13E
0005435981533	2323	28	13F
0005435981509	2323	29	13H
0005433753228	2323	30	13G
0005433753227	2323	31	14A
0005435981515	2323	32	14E
0005433753240	2323	33	14D
0005433753251	2323	34	14F
0005433753241	2323	35	14H
0005433753221	2323	36	14G
0005433753271	2323	37	15D
0005432300163	2323	38	15F
0005433753250	2323	39	15H
0005433753239	2323	40	15G
0005435981528	2323	41	16E
0005435981545	2323	42	16G
0005432225947	2323	43	16F
0005433753266	2323	44	17B
0005433753253	2323	45	17A
0005435981518	2323	46	17D
0005433753224	2323	47	17E
0005433753242	2323	48	17G
0005432655331	2323	49	17H
0005433753254	2323	50	18B
0005432300165	2323	51	18D
0005433753232	2323	52	18F
0005435981540	2323	53	18H
0005433753237	2323	54	19B
0005433753259	2323	55	19A
0005433764644	2323	56	19D
0005433753233	2323	57	19F
0005435981546	2323	58	19H
0005433764643	2323	59	19G
0005435981523	2323	60	20A
0005433766573	2323	61	20E
0005435981543	2323	62	20D
0005433753261	2323	63	20G
0005435981531	2323	64	20F
0005435981542	2323	65	21A
0005432300161	2323	66	21F
0005433753255	2323	67	22A
0005432655332	2323	68	21G
0005432655333	2323	69	22B
0005435981530	2323	70	22E
0005433753235	2323	71	22F
0005433753263	2323	72	22H
0005435981517	2323	73	23F
0005435981547	2323	74	23E
0005435981516	2323	75	24B
0005433753245	2323	76	24D
0005433753230	2323	77	24H
0005433753272	2323	78	24G
0005435981539	2323	79	25D
0005433753225	2323	80	25E
0005432655336	2323	81	27B
0005433766575	2323	82	27E
0005432225952	2323	83	27D
0005433753277	2323	84	27G
0005433753231	2323	85	27F
0005432655328	2323	86	27H
0005432225950	2323	87	28B
0005432300162	2323	88	28H
0005433753238	2323	89	28G
0005433753229	2323	90	29A
0005435981522	2323	91	29G
0005432225949	2323	92	30B
0005433753260	2323	93	30A
0005435981521	2323	94	30D
0005433753265	2323	95	30F
0005435981532	2323	96	30E
0005433753274	2323	97	30G
0005433753247	2323	98	30H
0005435981536	2323	99	31B
0005432225951	2323	100	31A
0005435981526	2323	101	31G
0005432655326	2323	102	32A
0005435981538	2323	103	32B
0005435981529	2323	104	32E
0005433753256	2323	105	32H
0005433766572	2323	106	33A
0005433753226	2323	107	33B
0005435981508	2323	108	34A
0005433753248	2323	109	34D
0005432300164	2323	110	34E
0005435981520	2323	111	34G
0005433753222	2323	112	34F
0005435981512	2323	113	35A
0005433753234	2323	114	34H
0005433753270	2323	115	35B
0005433753236	2323	116	35D
0005435981544	2323	117	35E
0005433753264	2323	118	35H
0005433753257	2323	119	35G
0005432655330	2323	120	36F
0005433753252	2323	121	37D
0005435981541	2323	122	37A
0005432655329	2323	123	37G
0005435981524	2323	124	38A
0005433766574	2323	125	38G
0005432225948	2323	126	39E
0005433753276	2323	127	39D
0005435981525	2323	128	39F
0005432984529	26185	1	1A
0005432051075	26185	2	1B
0005433434188	26185	3	1F
0005433434192	26185	4	1G
0005432984518	26185	5	2A
0005432984503	26185	6	2B
0005433434184	26185	7	3F
0005432984526	26185	8	4B
0005433434195	26185	9	4F
0005432984506	26185	10	5A
0005432984530	26185	11	5F
0005433434186	26185	12	9G
0005432984514	26185	13	11E
0005433434203	26185	14	12B
0005433434181	26185	15	12F
0005432984510	26185	16	12G
0005432984501	26185	17	13H
0005432984524	26185	18	14A
0005433434187	26185	19	14F
0005432984507	26185	20	15E
0005432984527	26185	21	16D
0005433434189	26185	22	16E
0005432984511	26185	23	17A
0005432984505	26185	24	18A
0005432984516	26185	25	18G
0005434731099	26185	26	19B
0005433434185	26185	27	19F
0005433434204	26185	28	19G
0005433434193	26185	29	20D
0005433434182	26185	30	20H
0005432984504	26185	31	21B
0005433434202	26185	32	22D
0005433434197	26185	33	22F
0005432984502	26185	34	22E
0005433434198	26185	35	23B
0005432984515	26185	36	23E
0005433434199	26185	37	24A
0005432984520	26185	38	24D
0005434731097	26185	39	24E
0005434731096	26185	40	24G
0005433434201	26185	41	27H
0005433434207	26185	42	29E
0005433434208	26185	43	29G
0005433434180	26185	44	29H
0005432984512	26185	45	30E
0005434731098	26185	46	31D
0005432049402	26185	47	31F
0005432051076	26185	48	31E
0005432984508	26185	49	31H
0005433434190	26185	50	32D
0005432984509	26185	51	32B
0005433434194	26185	52	32F
0005432051074	26185	53	33A
0005432049400	26185	54	33B
0005432984513	26185	55	33D
0005433434196	26185	56	33G
0005432984521	26185	57	33F
0005432984519	26185	58	34A
0005432984531	26185	59	34D
0005433434191	26185	60	35E
0005432984532	26185	61	35D
0005432984523	26185	62	36A
0005432984522	26185	63	36B
0005433434200	26185	64	36D
0005433434183	26185	65	36E
0005432984517	26185	66	37D
0005432984500	26185	67	38A
0005432049401	26185	68	38D
0005432984525	26185	69	38E
0005433434206	26185	70	38F
0005433434205	26185	71	39D
0005432984528	26185	72	39F
0005434373852	1521	1	1A
0005434373860	1521	2	1D
0005434373851	1521	3	2C
0005434373859	1521	4	2D
0005433460399	1521	5	3A
0005434373870	1521	6	2F
0005434373884	1521	7	3C
0005434373856	1521	8	4B
0005434373887	1521	9	4D
0005434373897	1521	10	5D
0005432267782	1521	11	5F
0005434373854	1521	12	6B
0005434373874	1521	13	6A
0005434373857	1521	14	6C
0005433461550	1521	15	6D
0005434373846	1521	16	6E
0005434373872	1521	17	7B
0005434373855	1521	18	7C
0005434373879	1521	19	7D
0005434373890	1521	20	9B
0005434373876	1521	21	9C
0005432267778	1521	22	9E
0005434373867	1521	23	9F
0005434373869	1521	24	10B
0005434373861	1521	25	10E
0005434373847	1521	26	10D
0005434373878	1521	27	11A
0005434373881	1521	28	11D
0005434373894	1521	29	11C
0005434373891	1521	30	11E
0005434373873	1521	31	11F
0005434373888	1521	32	12B
0005434373895	1521	33	12D
0005434373877	1521	34	12E
0005433460398	1521	35	13B
0005434373853	1521	36	13D
0005434373864	1521	37	13C
0005434373893	1521	38	13F
0005434373885	1521	39	14C
0005434373849	1521	40	14B
0005432267780	1521	41	15B
0005434373880	1521	42	16E
0005434373848	1521	43	17B
0005434373883	1521	44	17C
0005434373875	1521	45	17F
0005434373862	1521	46	17E
0005432267779	1521	47	18B
0005434373863	1521	48	18C
0005433461551	1521	49	18D
0005434373882	1521	50	19A
0005432267777	1521	51	19B
0005434373865	1521	52	19D
0005434373868	1521	53	20B
0005434373889	1521	54	20D
0005432267781	1521	55	20E
0005434373886	1521	56	21A
0005434373866	1521	57	21C
0005434373850	1521	58	22C
0005434373871	1521	59	22D
0005434373892	1521	60	23A
0005434373858	1521	61	23B
0005434373896	1521	62	23D
0005433150802	20159	1	1D
0005433150806	20159	2	1F
0005433150801	20159	3	2A
0005433150825	20159	4	3D
0005433931415	20159	5	3F
0005433150796	20159	6	4B
0005433931414	20159	7	4F
0005433150820	20159	8	5B
0005432056231	20159	9	5A
0005432056232	20159	10	5F
0005433150817	20159	11	6D
0005432056233	20159	12	7B
0005433150808	20159	13	7D
0005433150809	20159	14	7E
0005433931413	20159	15	8C
0005433150819	20159	16	8F
0005433150804	20159	17	9D
0005434029615	20159	18	10C
0005433764643	20159	19	11C
0005433150795	20159	20	11B
0005433150812	20159	21	11E
0005433150816	20159	22	11D
0005433150799	20159	23	12D
0005432056234	20159	24	13A
0005433931416	20159	25	13C
0005433150818	20159	26	13B
0005433150803	20159	27	13E
0005433150826	20159	28	13F
0005433150821	20159	29	14D
0005434029613	20159	30	14F
0005433150797	20159	31	15B
0005433150807	20159	32	15C
0005433150824	20159	33	15D
0005433150794	20159	34	15E
0005433150822	20159	35	16B
0005433150813	20159	36	16C
0005433150811	20159	37	17B
0005433150815	20159	38	17C
0005434029614	20159	39	17F
0005433150810	20159	40	18E
0005433150805	20159	41	18F
0005433150800	20159	42	19A
0005433150814	20159	43	21C
0005433150798	20159	44	22C
0005433150823	20159	45	22E
0005433764644	20159	46	23B
0005433150827	20159	47	23A
0005432423614	533	1	1D
0005432423631	533	2	2C
0005432282742	533	3	4C
0005432282744	533	4	7A
0005432423633	533	5	8B
0005432423621	533	6	8C
0005432423607	533	7	10B
0005432423644	533	8	10D
0005432423626	533	9	10E
0005432423612	533	10	11F
0005432423605	533	11	11E
0005432282745	533	12	12B
0005432282740	533	13	12D
0005432423618	533	14	12C
0005432423634	533	15	12E
0005432423623	533	16	13D
0005432423642	533	17	13F
0005432423637	533	18	14D
0005432423632	533	19	15A
0005432423645	533	20	15B
0005432423630	533	21	15E
0005432423604	533	22	15D
0005432423617	533	23	16C
0005432423616	533	24	17F
0005432423643	533	25	18B
0005432282746	533	26	18E
0005432423609	533	27	18F
0005432423610	533	28	19C
0005432423635	533	29	19D
0005432423639	533	30	20D
0005432423646	533	31	20E
0005432423638	533	32	21A
0005432423606	533	33	21F
0005432423628	533	34	22C
0005432423627	533	35	23A
0005432423622	533	36	23B
0005432282739	533	37	23C
0005432423611	533	38	23F
0005432423641	533	39	24C
0005432423640	533	40	24D
0005432423636	533	41	25E
0005432423613	533	42	25F
0005432423625	533	43	26B
0005432423620	533	44	26E
0005432423608	533	45	26F
0005432282743	533	46	27A
0005432423619	533	47	28B
0005432423624	533	48	28F
0005432423629	533	49	29A
0005432282741	533	50	29D
0005432423647	533	51	30A
0005432423615	533	52	31E
0005432302265	12840	1	7C
0005432302266	12840	2	9F
0005433158094	12840	3	24C
0005433158093	12840	4	24F
0005434022558	478	1	1G
0005434022550	478	2	2B
0005432235505	478	3	2G
0005434022515	478	4	2H
0005434022561	478	5	3G
0005434022537	478	6	4A
0005434022536	478	7	3H
0005434022507	478	8	4F
0005434022534	478	9	5B
0005432235507	478	10	5G
0005434022547	478	11	11A
0005434022528	478	12	11E
0005434022520	478	13	11G
0005434022502	478	14	12D
0005434022553	478	15	12E
0005434022525	478	16	12H
0005434022506	478	17	13F
0005434022503	478	18	14B
0005434022562	478	19	14G
0005434022541	478	20	15E
0005434022565	478	21	15F
0005432235508	478	22	15H
0005434022521	478	23	15G
0005434022527	478	24	16A
0005434022542	478	25	16F
0005432235512	478	26	16D
0005434022512	478	27	17D
0005434022524	478	28	17F
0005434022519	478	29	17G
0005434022508	478	30	18E
0005432235506	478	31	18G
0005434022556	478	32	19E
0005434022510	478	33	20D
0005434022538	478	34	20F
0005434022567	478	35	21D
0005434022539	478	36	21H
0005434022530	478	37	21G
0005434022533	478	38	22D
0005434022516	478	39	22G
0005434022531	478	40	23A
0005434022505	478	41	23D
0005434022523	478	42	23H
0005434022535	478	43	24B
0005434022568	478	44	24D
0005434022548	478	45	24F
0005434022540	478	46	27A
0005434022549	478	47	27E
0005434022564	478	48	28F
0005434022513	478	49	28H
0005434022552	478	50	29D
0005432235509	478	51	29G
0005434022529	478	52	29F
0005434022517	478	53	30A
0005434022557	478	54	31A
0005434022545	478	55	30H
0005434022546	478	56	31B
0005434022518	478	57	31F
0005432235510	478	58	31G
0005434022560	478	59	32D
0005434022544	478	60	33A
0005434022563	478	61	33E
0005434022543	478	62	33F
0005432235504	478	63	33H
0005434022509	478	64	33G
0005434022522	478	65	34E
0005434022555	478	66	34G
0005434022566	478	67	35B
0005434022511	478	68	35E
0005434022551	478	69	35G
0005434022504	478	70	36A
0005432235511	478	71	35H
0005434022532	478	72	37B
0005434022559	478	73	37E
0005434022514	478	74	37H
0005434022501	478	75	38D
0005434022526	478	76	38H
0005434022569	478	77	39F
0005434022554	478	78	39E
0005432156288	12679	1	1B
0005434735601	12679	2	1F
0005433057203	12679	3	2F
0005433057204	12679	4	2G
0005433929541	12679	5	4A
0005433057198	12679	6	4C
0005433057179	12679	7	4F
0005433057182	12679	8	5F
0005433057190	12679	9	9A
0005433057194	12679	10	11A
0005433929539	12679	11	11E
0005433057206	12679	12	11H
0005433057196	12679	13	12H
0005433929540	12679	14	13F
0005433057168	12679	15	13H
0005433057187	12679	16	14D
0005433057181	12679	17	15F
0005433057191	12679	18	16A
0005433057176	12679	19	16D
0005433057174	12679	20	17B
0005433057169	12679	21	17F
0005433057170	12679	22	18A
0005433057197	12679	23	18E
0005432156289	12679	24	19B
0005433057178	12679	25	19G
0005433057183	12679	26	20E
0005433057172	12679	27	20F
0005432156290	12679	28	21A
0005433057193	12679	29	20H
0005433057188	12679	30	21B
0005433057180	12679	31	22B
0005432156286	12679	32	22D
0005432157457	12679	33	22E
0005433057202	12679	34	22F
0005433057189	12679	35	23E
0005433057200	12679	36	23F
0005433057173	12679	37	24A
0005433057205	12679	38	24H
0005433057184	12679	39	27G
0005433057175	12679	40	28A
0005433057186	12679	41	29G
0005433057195	12679	42	29F
0005433057199	12679	43	30A
0005432156287	12679	44	30G
0005433057201	12679	45	31G
0005433057208	12679	46	32A
0005434735600	12679	47	32F
0005433057192	12679	48	32G
0005433929542	12679	49	33A
0005434735599	12679	50	33G
0005433684385	12679	51	34D
0005433057185	12679	52	34B
0005432157458	12679	53	36D
0005434735597	12679	54	36F
0005433684384	12679	55	36G
0005433057171	12679	56	37A
0005433057207	12679	57	36H
0005434735598	12679	58	37H
0005433057177	12679	59	38E
0005433921597	2140	1	1A
0005432231380	2140	2	1C
0005433921601	2140	3	1B
0005433921643	2140	4	1F
0005433929540	2140	5	1G
0005433921659	2140	6	2C
0005433921667	2140	7	2H
0005433931415	2140	8	2G
0005433921590	2140	9	4B
0005433921655	2140	10	4H
0005433921623	2140	11	4F
0005433921665	2140	12	5A
0005433921605	2140	13	5B
0005433921624	2140	14	5C
0005432231376	2140	15	5G
0005433921621	2140	16	5H
0005433921673	2140	17	9B
0005432231384	2140	18	9G
0005433921661	2140	19	9H
0005433921650	2140	20	11B
0005432044477	2140	21	11D
0005433929539	2140	22	11G
0005433921632	2140	23	12A
0005433921594	2140	24	12B
0005433921660	2140	25	12H
0005433921642	2140	26	13B
0005433921639	2140	27	13A
0005433921684	2140	28	13F
0005433921668	2140	29	13E
0005433921680	2140	30	13H
0005433921603	2140	31	14F
0005433921615	2140	32	14E
0005432231377	2140	33	15A
0005433921600	2140	34	15B
0005433921629	2140	35	15E
0005433931416	2140	36	15F
0005433921619	2140	37	16B
0005433921611	2140	38	16A
0005433921675	2140	39	15H
0005433921656	2140	40	16D
0005433921618	2140	41	16H
0005433921654	2140	42	16G
0005433921666	2140	43	17A
0005433921634	2140	44	17B
0005433921644	2140	45	17G
0005433921630	2140	46	17F
0005433921636	2140	47	17H
0005433921671	2140	48	18E
0005433921648	2140	49	18F
0005433931414	2140	50	19A
0005433921587	2140	51	19D
0005433921649	2140	52	19F
0005433921682	2140	53	19H
0005433921622	2140	54	19G
0005433921638	2140	55	20D
0005433921664	2140	56	20B
0005433921683	2140	57	20E
0005432231379	2140	58	20H
0005432044476	2140	59	21E
0005433921606	2140	60	21H
0005433921633	2140	61	22B
0005433921598	2140	62	22G
0005433921646	2140	63	22F
0005433921672	2140	64	23A
0005433921610	2140	65	22H
0005432231378	2140	66	23D
0005433921626	2140	67	23E
0005433921658	2140	68	23G
0005433921663	2140	69	24D
0005433921676	2140	70	24F
0005433921631	2140	71	24G
0005433921662	2140	72	25E
0005433921670	2140	73	27A
0005433921678	2140	74	27E
0005433921645	2140	75	27D
0005432044475	2140	76	27F
0005433921608	2140	77	27H
0005433921681	2140	78	28H
0005432231375	2140	79	29D
0005433921669	2140	80	29B
0005433921637	2140	81	29F
0005433921652	2140	82	30A
0005433921604	2140	83	30B
0005433921635	2140	84	30E
0005433931413	2140	85	30D
0005433921641	2140	86	30F
0005433921651	2140	87	30G
0005432231383	2140	88	31A
0005433921627	2140	89	31E
0005433921628	2140	90	31G
0005433921588	2140	91	32A
0005433921647	2140	92	31H
0005433929542	2140	93	32E
0005433921620	2140	94	33A
0005433921674	2140	95	33B
0005433921614	2140	96	33D
0005433921679	2140	97	33G
0005433921653	2140	98	33F
0005433921613	2140	99	33H
0005433921616	2140	100	34B
0005433921595	2140	101	34A
0005433921677	2140	102	34D
0005433921612	2140	103	34F
0005432231382	2140	104	34E
0005432231381	2140	105	34H
0005433921589	2140	106	35B
0005433921609	2140	107	35F
0005433921640	2140	108	35H
0005433921602	2140	109	35G
0005433921593	2140	110	36B
0005433921657	2140	111	36A
0005433929541	2140	112	36E
0005433921617	2140	113	36F
0005433921592	2140	114	36H
0005433921599	2140	115	37A
0005433921625	2140	116	37F
0005433921596	2140	117	37H
0005432231374	2140	118	38A
0005433921591	2140	119	38E
0005433921607	2140	120	38F
0005433035392	24118	1	1B
0005433035386	24118	2	1F
0005433035391	24118	3	1G
0005433035374	24118	4	2H
0005433035377	24118	5	3G
0005433035396	24118	6	4C
0005433035388	24118	7	5B
0005433035390	24118	8	9A
0005433035364	24118	9	11E
0005433035369	24118	10	11F
0005433035378	24118	11	12A
0005433035398	24118	12	11H
0005432206096	24118	13	12G
0005432207616	24118	14	13E
0005433035381	24118	15	13H
0005433035393	24118	16	14G
0005433035379	24118	17	14F
0005433035384	24118	18	15A
0005433035383	24118	19	15F
0005433035356	24118	20	16D
0005433035370	24118	21	16G
0005432207617	24118	22	17B
0005433035409	24118	23	18B
0005433035380	24118	24	18G
0005433035358	24118	25	18F
0005433035397	24118	26	18H
0005433035373	24118	27	19D
0005432206094	24118	28	19H
0005433035403	24118	29	19G
0005433035366	24118	30	20E
0005433035368	24118	31	20G
0005432206091	24118	32	21F
0005433035404	24118	33	22A
0005433035406	24118	34	22D
0005433035365	24118	35	22F
0005433035371	24118	36	22E
0005433035407	24118	37	23E
0005434028249	24118	38	23G
0005433035375	24118	39	23F
0005433035372	24118	40	24B
0005433035405	24118	41	24E
0005433035385	24118	42	24D
0005433035387	24118	43	24H
0005432207618	24118	44	25D
0005432206093	24118	45	27A
0005433035394	24118	46	27D
0005433035367	24118	47	27E
0005433035363	24118	48	30F
0005433035376	24118	49	30H
0005433035399	24118	50	31D
0005432206095	24118	51	32H
0005434028247	24118	52	32G
0005433035360	24118	53	33A
0005433035410	24118	54	33E
0005433035361	24118	55	34B
0005433035357	24118	56	34A
0005433035389	24118	57	35B
0005433035359	24118	58	35E
0005433035395	24118	59	35D
0005433035400	24118	60	35G
0005434028246	24118	61	36D
0005433035362	24118	62	36E
0005432206092	24118	63	37B
0005433035408	24118	64	37E
0005432749747	24118	65	37D
0005433035401	24118	66	37G
0005433035402	24118	67	37F
0005433035382	24118	68	37H
0005434028248	24118	69	38D
0005432749748	24118	70	38G
0005434550284	277	1	1C
0005434723419	277	2	1A
0005434723381	277	3	1H
0005434723410	277	4	1G
0005434550305	277	5	2A
0005434723388	277	6	1K
0005434550256	277	7	2C
0005434550307	277	8	2G
0005434723407	277	9	2K
0005434550275	277	10	3H
0005434723327	277	11	3K
0005435142344	277	12	4D
0005434723399	277	13	5A
0005434723343	277	14	4H
0005434723346	277	15	5H
0005434723421	277	16	5G
0005434550303	277	17	5K
0005434723394	277	18	11C
0005434723349	277	19	11F
0005434550294	277	20	11G
0005434302381	277	21	12C
0005432277569	277	22	11K
0005434550293	277	23	12G
0005434723359	277	24	13A
0005434723352	277	25	12H
0005432277572	277	26	13C
0005434550288	277	27	13G
0005434723325	277	28	13F
0005434723391	277	29	13E
0005434550270	277	30	13H
0005435142348	277	31	14C
0005434723402	277	32	14A
0005434550276	277	33	14G
0005434550281	277	34	14F
0005432277575	277	35	14E
0005434550263	277	36	15C
0005434723373	277	37	15K
0005434723337	277	38	16D
0005434723378	277	39	16E
0005434723329	277	40	17C
0005434550286	277	41	17E
0005434723431	277	42	17D
0005434550260	277	43	18A
0005434550299	277	44	18B
0005432277580	277	45	18E
0005434723334	277	46	18D
0005434550267	277	47	18C
0005434723355	277	48	18G
0005434550291	277	49	18J
0005434723396	277	50	19B
0005432277574	277	51	19A
0005434550258	277	52	19H
0005434723395	277	53	19G
0005435142337	277	54	19K
0005434550279	277	55	20C
0005434723312	277	56	20B
0005434550277	277	57	20A
0005434723351	277	58	20E
0005434723379	277	59	20D
0005434723314	277	60	20G
0005434723424	277	61	20J
0005434723360	277	62	20H
0005434550283	277	63	21A
0005434723414	277	64	21D
0005434723389	277	65	21C
0005434550306	277	66	21G
0005434550287	277	67	22C
0005435142347	277	68	22G
0005434723433	277	69	22J
0005434723423	277	70	23B
0005434550309	277	71	23A
0005434723345	277	72	23D
0005434723365	277	73	23F
0005434723320	277	74	23E
0005435142341	277	75	23J
0005432277577	277	76	24D
0005434302382	277	77	23K
0005435142342	277	78	24E
0005434723393	277	79	25A
0005434550269	277	80	25D
0005434723366	277	81	25B
0005434723356	277	82	25E
0005434723335	277	83	25G
0005434550265	277	84	26A
0005434723357	277	85	25J
0005435142343	277	86	26C
0005435142346	277	87	26B
0005434723374	277	88	26E
0005434550259	277	89	26H
0005434550268	277	90	26F
0005434723417	277	91	26J
0005434723316	277	92	27D
0005434723406	277	93	27B
0005434723418	277	94	27E
0005434723368	277	95	27J
0005432277581	277	96	28B
0005434550262	277	97	28E
0005434723386	277	98	28D
0005434723403	277	99	28G
0005434550264	277	100	28F
0005434723430	277	101	28H
0005434723333	277	102	29A
0005434723390	277	103	29D
0005434723341	277	104	29C
0005434723321	277	105	29F
0005434550310	277	106	29E
0005434723432	277	107	29J
0005432277571	277	108	29H
0005434723408	277	109	30C
0005434550280	277	110	30B
0005434723319	277	111	30D
0005434723330	277	112	30G
0005434723411	277	113	30J
0005434723369	277	114	31A
0005434550257	277	115	31C
0005434723323	277	116	31E
0005434723380	277	117	31G
0005434723354	277	118	31K
0005434723370	277	119	31J
0005434550300	277	120	32E
0005434723363	277	121	32D
0005435142340	277	122	32F
0005434723383	277	123	32K
0005434550301	277	124	33D
0005434302853	277	125	33C
0005434723364	277	126	33H
0005434723331	277	127	34A
0005434723413	277	128	33K
0005434723313	277	129	33J
0005434723342	277	130	34B
0005434723398	277	131	34E
0005435142335	277	132	34C
0005434723427	277	133	34K
0005434723404	277	134	34J
0005434723362	277	135	35B
0005434723416	277	136	35D
0005434723361	277	137	35C
0005434723382	277	138	35E
0005432277579	277	139	35H
0005434550272	277	140	36A
0005434723353	277	141	36C
0005435142339	277	142	36D
0005434723412	277	143	36K
0005435142338	277	144	36J
0005434723318	277	145	37D
0005434723387	277	146	37C
0005434302383	277	147	37F
0005434550278	277	148	37E
0005434550298	277	149	37J
0005434723348	277	150	38A
0005434723409	277	151	37K
0005434302384	277	152	38C
0005434723385	277	153	38H
0005434723311	277	154	39B
0005434550261	277	155	39A
0005434723336	277	156	39D
0005435142336	277	157	39H
0005434723338	277	158	39K
0005434723344	277	159	39J
0005434723367	277	160	40B
0005432277576	277	161	40D
0005434723392	277	162	40K
0005434723384	277	163	41B
0005434550297	277	164	41D
0005432277573	277	165	41C
0005434550285	277	166	41G
0005434550266	277	167	41E
0005434550302	277	168	41K
0005432277578	277	169	41J
0005434723347	277	170	42C
0005434723428	277	171	42B
0005434723332	277	172	42D
0005434723426	277	173	42G
0005434723375	277	174	43D
0005434723339	277	175	43E
0005434723415	277	176	43H
0005434723425	277	177	43G
0005434723317	277	178	43K
0005434723324	277	179	43J
0005434723315	277	180	44A
0005434550290	277	181	44D
0005434723372	277	182	44C
0005434723326	277	183	45B
0005434723340	277	184	45J
0005434723350	277	185	45G
0005434550308	277	186	45K
0005434550274	277	187	46B
0005434723310	277	188	46A
0005434723422	277	189	46D
0005434723401	277	190	46F
0005434550282	277	191	46K
0005434723376	277	192	47C
0005434723377	277	193	47E
0005434550289	277	194	47D
0005434302385	277	195	47F
0005434723429	277	196	48A
0005434723400	277	197	48F
0005434550296	277	198	48E
0005434550273	277	199	48D
0005434723397	277	200	48H
0005434723322	277	201	48G
0005434550271	277	202	49C
0005434550295	277	203	49A
0005434723420	277	204	49F
0005434550304	277	205	49E
0005434723358	277	206	49H
0005434723405	277	207	50A
0005434723371	277	208	50H
0005434550311	277	209	50F
0005435142345	277	210	51D
0005432277570	277	211	50K
0005434723328	277	212	51E
0005434550292	277	213	51G
0005433233127	9829	1	1A
0005434031947	9829	2	1G
0005433233121	9829	3	1K
0005433180671	9829	4	2C
0005432199129	9829	5	2G
0005433180649	9829	6	3G
0005432199128	9829	7	4G
0005433180661	9829	8	4D
0005433180665	9829	9	4H
0005433233138	9829	10	5D
0005433233096	9829	11	5H
0005432199126	9829	12	11A
0005433233093	9829	13	11D
0005433233111	9829	14	11G
0005433180667	9829	15	11F
0005433233097	9829	16	11H
0005433233110	9829	17	12C
0005433233112	9829	18	13A
0005433180672	9829	19	12H
0005433180664	9829	20	13C
0005433180657	9829	21	13K
0005433233103	9829	22	13G
0005433233091	9829	23	14G
0005433233102	9829	24	15H
0005433233107	9829	25	15G
0005433233118	9829	26	15F
0005433233089	9829	27	18C
0005433233124	9829	28	18A
0005433180653	9829	29	18E
0005433233090	9829	30	18F
0005433233114	9829	31	19A
0005433233143	9829	32	19D
0005433233133	9829	33	19C
0005433233108	9829	34	20F
0005433180673	9829	35	21C
0005433233117	9829	36	21J
0005433113496	9829	37	21H
0005434031946	9829	38	23B
0005433180670	9829	39	23E
0005433233092	9829	40	23H
0005432199123	9829	41	23K
0005433233085	9829	42	25E
0005433233134	9829	43	25H
0005433180668	9829	44	26E
0005433233131	9829	45	26D
0005433766574	9829	46	26F
0005433233080	9829	47	26J
0005433180660	9829	48	27A
0005433233116	9829	49	27C
0005432199124	9829	50	28A
0005433180654	9829	51	28C
0005433180669	9829	52	28B
0005433766573	9829	53	28E
0005433180651	9829	54	28G
0005433233125	9829	55	28J
0005433233115	9829	56	29B
0005432199127	9829	57	29G
0005433233141	9829	58	30B
0005433233086	9829	59	30E
0005433233139	9829	60	30C
0005432199125	9829	61	30J
0005433766575	9829	62	30K
0005433233101	9829	63	31D
0005433233105	9829	64	31F
0005433113495	9829	65	31E
0005433233135	9829	66	31K
0005433180659	9829	67	32H
0005433233123	9829	68	33B
0005433233119	9829	69	32K
0005433233082	9829	70	33K
0005433233120	9829	71	34E
0005433233100	9829	72	35K
0005433233136	9829	73	36F
0005433233099	9829	74	36H
0005433233113	9829	75	36G
0005433233130	9829	76	37F
0005433233126	9829	77	37E
0005433233083	9829	78	37G
0005434031945	9829	79	38A
0005433180655	9829	80	37K
0005433233140	9829	81	39C
0005433233137	9829	82	39B
0005434031944	9829	83	39D
0005433766572	9829	84	40D
0005433180652	9829	85	40F
0005433233129	9829	86	41A
0005433180666	9829	87	41D
0005433233142	9829	88	42A
0005433180648	9829	89	41J
0005433233109	9829	90	42G
0005433180663	9829	91	43D
0005433233088	9829	92	43K
0005433233122	9829	93	44B
0005433233104	9829	94	44H
0005433233095	9829	95	44G
0005433180662	9829	96	45A
0005433233106	9829	97	45E
0005433233094	9829	98	45G
0005433180656	9829	99	46D
0005433233098	9829	100	46J
0005433233128	9829	101	47F
0005433233084	9829	102	48G
0005433233081	9829	103	48K
0005433233132	9829	104	49C
0005433180658	9829	105	49H
0005433180650	9829	106	50E
0005433233087	9829	107	50H
0005432525678	7768	1	1C
0005432525723	7768	2	1A
0005432525761	7768	3	2A
0005434066299	7768	4	1K
0005432525677	7768	5	1H
0005432525642	7768	6	2D
0005432525709	7768	7	2C
0005434066325	7768	8	2G
0005432150061	7768	9	3C
0005434066354	7768	10	3K
0005434066360	7768	11	3H
0005434066313	7768	12	3G
0005432525732	7768	13	4A
0005434066306	7768	14	4G
0005432533242	7768	15	5C
0005432525674	7768	16	5A
0005432525694	7768	17	5D
0005432069406	7768	18	11A
0005432525731	7768	19	5K
0005432525648	7768	20	11D
0005432525634	7768	21	11C
0005432525645	7768	22	11F
0005434066327	7768	23	11E
0005432525727	7768	24	11H
0005434066321	7768	25	11G
0005434066332	7768	26	12C
0005432525744	7768	27	12A
0005432525666	7768	28	12D
0005434066351	7768	29	12F
0005432525733	7768	30	12K
0005432525655	7768	31	13C
0005432525686	7768	32	13F
0005432150057	7768	33	13E
0005434066343	7768	34	13G
0005432535748	7768	35	14A
0005434066322	7768	36	13K
0005432525735	7768	37	14E
0005434066305	7768	38	14H
0005432525730	7768	39	14G
0005434066317	7768	40	15C
0005432525710	7768	41	15A
0005432525667	7768	42	15D
0005432150055	7768	43	15G
0005432525701	7768	44	15K
0005432525669	7768	45	16D
0005432525639	7768	46	16C
0005434066334	7768	47	16E
0005432525765	7768	48	16K
0005434066352	7768	49	17E
0005432525647	7768	50	17G
0005432525739	7768	51	17F
0005434066315	7768	52	18A
0005432525767	7768	53	17K
0005434066355	7768	54	18C
0005432525654	7768	55	18B
0005432525658	7768	56	18E
0005432525644	7768	57	18D
0005434066335	7768	58	18G
0005434066342	7768	59	18F
0005432525736	7768	60	18H
0005434066346	7768	61	19B
0005432150060	7768	62	18K
0005432525662	7768	63	19D
0005434066341	7768	64	19C
0005432525729	7768	65	19H
0005432150054	7768	66	19G
0005432525696	7768	67	19J
0005432525691	7768	68	20B
0005432525697	7768	69	20E
0005432525718	7768	70	20C
0005432525703	7768	71	20F
0005434066362	7768	72	20K
0005432525646	7768	73	21B
0005434066324	7768	74	21A
0005432525685	7768	75	21D
0005434066353	7768	76	21C
0005432525747	7768	77	21H
0005434066340	7768	78	21G
0005434066345	7768	79	22A
0005434066303	7768	80	22D
0005432525716	7768	81	22C
0005432533241	7768	82	22B
0005434066304	7768	83	22E
0005432525668	7768	84	22H
0005432069400	7768	85	22G
0005432069397	7768	86	22J
0005434066333	7768	87	23B
0005432150059	7768	88	23A
0005432535746	7768	89	23D
0005434066326	7768	90	23G
0005432525742	7768	91	23F
0005434066361	7768	92	23J
0005434066295	7768	93	23H
0005434066323	7768	94	24D
0005432428867	7768	95	24F
0005434066318	7768	96	25B
0005432525649	7768	97	25A
0005432150058	7768	98	24G
0005434066319	7768	99	25D
0005434066328	7768	100	25C
0005432525670	7768	101	25F
0005432069404	7768	102	25H
0005432525741	7768	103	25K
0005432069394	7768	104	25J
0005432525754	7768	105	26A
0005434066364	7768	106	26E
0005432525746	7768	107	26G
0005434066316	7768	108	26F
0005432525687	7768	109	26K
0005432525758	7768	110	26J
0005432535745	7768	111	27A
0005434066312	7768	112	27B
0005432525692	7768	113	27E
0005432525635	7768	114	27H
0005432525664	7768	115	27G
0005434066349	7768	116	27J
0005432525714	7768	117	28C
0005432525659	7768	118	28B
0005432525683	7768	119	28G
0005434066366	7768	120	28J
0005432525725	7768	121	28H
0005432525745	7768	122	29B
0005432525766	7768	123	29A
0005434066358	7768	124	28K
0005432525759	7768	125	29C
0005434066300	7768	126	29G
0005432525652	7768	127	30A
0005432525715	7768	128	29J
0005434066314	7768	129	30B
0005432525719	7768	130	30F
0005432069401	7768	131	30K
0005432525717	7768	132	30J
0005432525763	7768	133	31D
0005432525762	7768	134	31G
0005434066302	7768	135	31K
0005434066365	7768	136	31J
0005432069407	7768	137	32C
0005432525748	7768	138	32E
0005434066344	7768	139	32D
0005432525698	7768	140	32G
0005432069403	7768	141	32J
0005432525637	7768	142	32H
0005432525653	7768	143	33B
0005432525651	7768	144	33D
0005432525713	7768	145	33F
0005432525671	7768	146	33J
0005432525700	7768	147	33G
0005434066330	7768	148	34A
0005432525663	7768	149	33K
0005434066297	7768	150	34C
0005434066298	7768	151	34B
0005434066348	7768	152	34D
0005432525721	7768	153	34G
0005434066307	7768	154	34F
0005432535747	7768	155	34J
0005432069399	7768	156	35A
0005432525724	7768	157	35C
0005432525753	7768	158	35J
0005434066331	7768	159	35H
0005432150062	7768	160	36A
0005432069408	7768	161	35K
0005432525752	7768	162	36C
0005434066311	7768	163	36B
0005434066329	7768	164	36F
0005432150056	7768	165	36E
0005432525720	7768	166	36D
0005432525638	7768	167	36K
0005432525665	7768	168	36J
0005432428869	7768	169	37B
0005432525656	7768	170	37E
0005432525705	7768	171	37J
0005432525690	7768	172	38A
0005434066339	7768	173	37K
0005434066350	7768	174	38C
0005432525737	7768	175	38J
0005432525707	7768	176	39B
0005432428868	7768	177	39G
0005432525755	7768	178	39F
0005434066320	7768	179	39D
0005432525702	7768	180	39K
0005432525641	7768	181	39J
0005432525751	7768	182	40C
0005432069395	7768	183	40B
0005434066310	7768	184	40F
0005434066296	7768	185	40D
0005432525726	7768	186	40K
0005432525689	7768	187	40J
0005432525693	7768	188	41A
0005432525643	7768	189	41D
0005432525673	7768	190	41C
0005432535749	7768	191	41F
0005432525681	7768	192	41E
0005432525704	7768	193	41H
0005432525738	7768	194	41G
0005434066338	7768	195	42A
0005432525688	7768	196	41K
0005432525650	7768	197	42B
0005432525708	7768	198	42E
0005432525743	7768	199	42K
0005432525657	7768	200	42J
0005432525660	7768	201	43C
0005432525695	7768	202	43F
0005432525640	7768	203	43G
0005432525672	7768	204	43K
0005432069396	7768	205	43J
0005432525712	7768	206	44B
0005434066337	7768	207	44E
0005434066356	7768	208	44G
0005432525757	7768	209	44F
0005432069402	7768	210	44K
0005432533240	7768	211	44H
0005432069398	7768	212	45B
0005432525760	7768	213	45F
0005434066336	7768	214	45H
0005432525756	7768	215	45G
0005432525675	7768	216	46E
0005432525699	7768	217	46D
0005432525722	7768	218	46G
0005434066359	7768	219	46F
0005432525636	7768	220	46H
0005432525740	7768	221	46K
0005432525734	7768	222	47D
0005434066357	7768	223	47C
0005432525728	7768	224	48A
0005432525676	7768	225	47K
0005432525711	7768	226	48C
0005432069405	7768	227	48E
0005434066309	7768	228	48H
0005432525749	7768	229	49A
0005434066363	7768	230	49D
0005432525706	7768	231	49C
0005432525679	7768	232	49G
0005432525684	7768	233	49F
0005432525682	7768	234	49K
0005432525680	7768	235	49H
0005432525750	7768	236	50C
0005432525764	7768	237	50A
0005434066301	7768	238	50E
0005434066308	7768	239	50D
0005434066347	7768	240	50F
0005432525661	7768	241	51E
0005435611762	5354	1	1A
0005434343587	5354	2	1H
0005432132951	5354	3	1G
0005434343593	5354	4	1K
0005435611739	5354	5	2H
0005435611766	5354	6	3A
0005435611757	5354	7	4H
0005434573103	5354	8	5C
0005435097048	5354	9	5A
0005435611769	5354	10	5G
0005434343591	5354	11	11C
0005435611727	5354	12	11G
0005434343600	5354	13	11F
0005435097051	5354	14	12C
0005432132947	5354	15	12F
0005435611699	5354	16	13D
0005435611731	5354	17	13C
0005435097047	5354	18	13A
0005432132954	5354	19	14A
0005432132942	5354	20	14E
0005435611713	5354	21	14C
0005434573110	5354	22	15C
0005435611722	5354	23	15E
0005434343611	5354	24	16A
0005434573104	5354	25	15K
0005435611700	5354	26	16C
0005435611743	5354	27	16F
0005435611754	5354	28	17D
0005434573106	5354	29	17K
0005432132955	5354	30	18C
0005435611701	5354	31	18B
0005434343609	5354	32	18D
0005435611746	5354	33	19F
0005435611737	5354	34	20E
0005435611755	5354	35	20D
0005435611748	5354	36	20F
0005435611715	5354	37	21H
0005435611733	5354	38	22B
0005432047485	5354	39	22F
0005434573101	5354	40	22J
0005435097044	5354	41	23F
0005435611740	5354	42	23H
0005432132941	5354	43	23K
0005434343605	5354	44	24G
0005434343608	5354	45	25E
0005435611738	5354	46	25G
0005435611698	5354	47	26A
0005435097043	5354	48	26D
0005435611717	5354	49	26H
0005434343610	5354	50	27A
0005432132953	5354	51	27C
0005435611750	5354	52	27B
0005434343599	5354	53	27F
0005435611742	5354	54	27J
0005434573102	5354	55	27G
0005432132944	5354	56	27K
0005434343603	5354	57	28E
0005435611734	5354	58	28G
0005435611714	5354	59	28F
0005435611712	5354	60	29B
0005435611702	5354	61	29C
0005432047484	5354	62	29G
0005435611741	5354	63	29F
0005435611751	5354	64	29H
0005432132952	5354	65	30E
0005435611708	5354	66	30D
0005435611719	5354	67	30G
0005434343589	5354	68	30J
0005435611756	5354	69	31E
0005434573107	5354	70	31H
0005435611764	5354	71	32C
0005434343613	5354	72	32B
0005434343597	5354	73	32D
0005434573115	5354	74	32G
0005435611753	5354	75	32F
0005432047486	5354	76	32J
0005435611707	5354	77	32K
0005434343586	5354	78	33C
0005435097049	5354	79	33H
0005435097050	5354	80	33G
0005434343615	5354	81	34A
0005435611763	5354	82	33K
0005434343595	5354	83	33J
0005435611730	5354	84	34G
0005434573114	5354	85	34K
0005435611725	5354	86	35B
0005435611723	5354	87	35F
0005435611710	5354	88	35E
0005435611726	5354	89	36A
0005434343585	5354	90	36B
0005434343602	5354	91	36E
0005435611771	5354	92	36G
0005432132945	5354	93	36K
0005435611718	5354	94	36J
0005434343604	5354	95	37A
0005434343590	5354	96	37D
0005434343582	5354	97	37C
0005434343592	5354	98	37G
0005434343601	5354	99	37J
0005434573108	5354	100	38A
0005434343594	5354	101	38H
0005435611765	5354	102	38C
0005435097046	5354	103	38B
0005435611761	5354	104	38J
0005432132948	5354	105	39B
0005435611706	5354	106	39E
0005434343584	5354	107	39J
0005435611760	5354	108	39H
0005432132943	5354	109	40A
0005432132949	5354	110	40B
0005435611745	5354	111	40D
0005435611705	5354	112	40H
0005435611728	5354	113	41B
0005434343606	5354	114	41D
0005435611759	5354	115	41C
0005434573111	5354	116	41G
0005435611711	5354	117	41F
0005435611709	5354	118	41K
0005434343588	5354	119	42C
0005435611724	5354	120	42B
0005434573105	5354	121	42E
0005435611767	5354	122	42G
0005435611752	5354	123	42H
0005435611758	5354	124	42K
0005434343607	5354	125	43C
0005434343596	5354	126	43J
0005435611772	5354	127	44C
0005434343583	5354	128	44A
0005434343598	5354	129	44E
0005432132946	5354	130	44H
0005435611768	5354	131	44G
0005435611720	5354	132	44J
0005435611747	5354	133	44K
0005435611721	5354	134	45F
0005434573113	5354	135	45J
0005435611732	5354	136	45H
0005434343612	5354	137	45K
0005435611703	5354	138	46C
0005434343614	5354	139	46B
0005435611729	5354	140	47C
0005435611716	5354	141	46K
0005435611770	5354	142	47F
0005435611749	5354	143	47K
0005434573109	5354	144	48D
0005435097045	5354	145	48F
0005432132950	5354	146	48G
0005434343616	5354	147	49C
0005435611736	5354	148	49A
0005434573112	5354	149	48K
0005435611704	5354	150	49G
0005435611744	5354	151	50H
0005435611735	5354	152	51G
0005434244460	10895	1	1A
0005432840976	10895	2	2H
0005435423601	10895	3	3H
0005435423610	10895	4	4D
0005434656521	10895	5	4K
0005432166845	10895	6	11A
0005432164904	10895	7	11F
0005434244482	10895	8	11H
0005434244467	10895	9	12C
0005435423600	10895	10	12E
0005435423613	10895	11	12H
0005435423615	10895	12	12G
0005434244474	10895	13	13C
0005434656520	10895	14	13F
0005435423623	10895	15	14D
0005434244476	10895	16	14G
0005435423591	10895	17	15D
0005432164906	10895	18	15A
0005434244471	10895	19	15E
0005433719080	10895	20	15G
0005435423637	10895	21	16C
0005435423626	10895	22	17C
0005435423594	10895	23	17A
0005435423616	10895	24	17D
0005435423639	10895	25	18B
0005435423642	10895	26	18D
0005435423640	10895	27	18J
0005434244480	10895	28	19A
0005434244455	10895	29	19D
0005434244477	10895	30	19G
0005435423619	10895	31	20E
0005435423627	10895	32	20F
0005434244473	10895	33	20H
0005435423644	10895	34	21B
0005435423598	10895	35	21A
0005435423587	10895	36	21D
0005434244461	10895	37	21G
0005435423631	10895	38	21K
0005435423643	10895	39	22E
0005435042820	10895	40	22K
0005435423614	10895	41	23B
0005434244464	10895	42	23A
0005434244463	10895	43	23K
0005435423582	10895	44	24F
0005435423595	10895	45	25F
0005433719082	10895	46	25J
0005435423592	10895	47	25H
0005434244459	10895	48	26C
0005434244458	10895	49	26B
0005435423636	10895	50	26D
0005432166844	10895	51	26G
0005435423584	10895	52	26K
0005435423612	10895	53	27D
0005435423576	10895	54	27C
0005435042822	10895	55	28C
0005434244472	10895	56	28B
0005435423632	10895	57	28A
0005435423588	10895	58	28G
0005435423617	10895	59	28J
0005434244457	10895	60	29H
0005432164902	10895	61	29K
0005435423645	10895	62	30E
0005435423604	10895	63	31B
0005435423628	10895	64	31D
0005435423597	10895	65	31F
0005435423599	10895	66	31H
0005432363359	10895	67	32C
0005435423622	10895	68	32K
0005432164903	10895	69	33B
0005434244456	10895	70	33D
0005435423634	10895	71	33C
0005432164901	10895	72	33F
0005434244475	10895	73	33H
0005434244470	10895	74	33K
0005435423583	10895	75	34E
0005435423578	10895	76	34F
0005434244479	10895	77	35C
0005434244481	10895	78	35F
0005435423586	10895	79	35H
0005435423620	10895	80	35G
0005432166843	10895	81	36A
0005435423638	10895	82	36C
0005434244483	10895	83	36F
0005433719081	10895	84	36H
0005435423635	10895	85	36G
0005435423589	10895	86	37E
0005435423608	10895	87	37D
0005435042821	10895	88	37C
0005435423577	10895	89	37G
0005435423603	10895	90	37H
0005435423580	10895	91	37J
0005432363360	10895	92	38J
0005434244466	10895	93	39A
0005435423633	10895	94	39G
0005434244469	10895	95	39K
0005435423593	10895	96	40E
0005435423611	10895	97	40G
0005435042823	10895	98	40K
0005434244465	10895	99	41F
0005433719083	10895	100	41E
0005435423596	10895	101	41K
0005435423579	10895	102	42B
0005435423605	10895	103	43C
0005435423609	10895	104	43B
0005435423629	10895	105	43G
0005434244453	10895	106	43J
0005432164907	10895	107	44H
0005435423624	10895	108	45B
0005435423621	10895	109	45D
0005435423641	10895	110	45H
0005435423602	10895	111	45G
0005434244468	10895	112	45K
0005435423625	10895	113	46D
0005435423618	10895	114	46K
0005435423585	10895	115	46H
0005435423607	10895	116	47C
0005435423581	10895	117	47G
0005434244454	10895	118	48F
0005432164905	10895	119	48H
0005435423590	10895	120	49C
0005434244478	10895	121	48K
0005432164908	10895	122	49D
0005435423606	10895	123	51D
0005435423630	10895	124	50K
0005435423575	10895	125	51F
0005434244462	10895	126	51G
0005433804786	3316	1	1F
0005433804791	3316	2	1D
0005433804793	3316	3	2D
0005433633228	3316	4	2C
0005433506853	3316	5	2F
0005433633225	3316	6	3A
0005433633239	3316	7	3F
0005433633226	3316	8	4A
0005433633227	3316	9	4D
0005432181320	3316	10	5C
0005433633217	3316	11	5F
0005433633231	3316	12	5D
0005433633222	3316	13	7A
0005433506856	3316	14	7C
0005433506855	3316	15	7F
0005433633214	3316	16	7D
0005433633221	3316	17	8C
0005433804780	3316	18	8B
0005432181330	3316	19	8D
0005433804788	3316	20	8F
0005433633213	3316	21	9A
0005432181331	3316	22	9C
0005433633220	3316	23	9E
0005433633245	3316	24	9D
0005433506857	3316	25	10A
0005433506861	3316	26	10C
0005432181325	3316	27	10B
0005432181339	3316	28	10D
0005433633247	3316	29	11B
0005433633241	3316	30	11C
0005433804782	3316	31	11D
0005432181329	3316	32	11F
0005432181327	3316	33	12B
0005432181332	3316	34	12E
0005433506866	3316	35	13A
0005433804790	3316	36	13D
0005432181323	3316	37	13E
0005433633244	3316	38	14A
0005433804787	3316	39	14D
0005433506867	3316	40	14C
0005433633229	3316	41	14F
0005433506870	3316	42	15B
0005432181322	3316	43	15A
0005433804781	3316	44	15E
0005432181324	3316	45	16A
0005433633219	3316	46	15F
0005433804778	3316	47	16C
0005433804783	3316	48	16E
0005433633224	3316	49	17B
0005433804784	3316	50	17C
0005433506862	3316	51	18A
0005432181321	3316	52	17F
0005432181333	3316	53	18C
0005433506868	3316	54	18E
0005433633230	3316	55	18F
0005432181334	3316	56	19C
0005433633235	3316	57	20B
0005432181337	3316	58	20A
0005433633215	3316	59	20E
0005433633233	3316	60	21B
0005433633242	3316	61	21D
0005433506860	3316	62	22B
0005433506869	3316	63	22A
0005433633234	3316	64	22D
0005433633216	3316	65	22C
0005433633223	3316	66	22F
0005433506859	3316	67	23A
0005433506858	3316	68	23B
0005433633237	3316	69	23D
0005432181335	3316	70	23C
0005433506854	3316	71	23F
0005432181340	3316	72	24B
0005433804777	3316	73	24E
0005432181319	3316	74	24F
0005433506863	3316	75	25A
0005432181326	3316	76	26A
0005433804789	3316	77	26C
0005433506871	3316	78	26E
0005432181336	3316	79	27A
0005432181338	3316	80	27D
0005433633232	3316	81	27F
0005433633236	3316	82	28A
0005433804785	3316	83	28D
0005433804792	3316	84	28C
0005433633243	3316	85	29B
0005433633246	3316	86	29A
0005433506864	3316	87	29C
0005432181328	3316	88	29E
0005433804779	3316	89	29F
0005433633218	3316	90	30B
0005433633238	3316	91	30A
0005433633240	3316	92	30F
0005433506865	3316	93	31C
0005435884382	8323	1	1C
0005432458972	8323	2	1A
0005432458984	8323	3	1F
0005435884409	8323	4	2A
0005432458964	8323	5	2C
0005432458973	8323	6	2D
0005435884393	8323	7	2F
0005432458992	8323	8	3D
0005432459008	8323	9	3C
0005435884385	8323	10	3F
0005435884375	8323	11	4D
0005435884414	8323	12	4F
0005432458980	8323	13	5D
0005432042479	8323	14	6A
0005432042473	8323	15	6C
0005432458965	8323	16	6D
0005432458991	8323	17	7C
0005432459003	8323	18	7F
0005432458999	8323	19	8D
0005435884405	8323	20	8C
0005435884410	8323	21	9A
0005432042478	8323	22	8F
0005435884408	8323	23	9B
0005432458978	8323	24	9C
0005432458956	8323	25	9D
0005432459005	8323	26	10A
0005435884411	8323	27	10B
0005432042469	8323	28	10D
0005435884384	8323	29	10C
0005435884377	8323	30	10E
0005432458979	8323	31	11C
0005432458967	8323	32	11B
0005432458993	8323	33	11D
0005435884417	8323	34	11E
0005435884378	8323	35	12A
0005435884418	8323	36	11F
0005435884415	8323	37	12C
0005432458990	8323	38	12E
0005432458995	8323	39	12D
0005432458963	8323	40	13A
0005432042471	8323	41	12F
0005432458962	8323	42	13B
0005432459001	8323	43	13C
0005435884420	8323	44	13F
0005435884425	8323	45	13E
0005432458971	8323	46	14A
0005432458996	8323	47	14C
0005435884381	8323	48	14D
0005435884372	8323	49	14E
0005435884424	8323	50	14F
0005435884373	8323	51	15B
0005432458960	8323	52	15F
0005435884374	8323	53	15E
0005435884422	8323	54	16A
0005435884391	8323	55	16C
0005432458985	8323	56	16F
0005435884401	8323	57	17B
0005432458970	8323	58	17C
0005435884407	8323	59	17D
0005432458968	8323	60	17E
0005432459006	8323	61	18B
0005434312283	8323	62	18D
0005435884386	8323	63	18C
0005432458974	8323	64	18E
0005434312284	8323	65	19C
0005435884412	8323	66	19B
0005432458977	8323	67	19E
0005435884389	8323	68	20B
0005435884404	8323	69	20A
0005432459000	8323	70	20D
0005435884397	8323	71	20C
0005432042475	8323	72	20E
0005432458966	8323	73	20F
0005435884383	8323	74	21A
0005435884371	8323	75	21C
0005432458988	8323	76	21E
0005435884426	8323	77	21D
0005432458975	8323	78	22B
0005435884402	8323	79	22A
0005435884398	8323	80	22D
0005435884396	8323	81	22C
0005435884416	8323	82	22E
0005432458997	8323	83	23A
0005435884390	8323	84	23C
0005435884370	8323	85	23B
0005432458983	8323	86	23D
0005435884394	8323	87	23E
0005432042472	8323	88	24A
0005435884400	8323	89	23F
0005432042476	8323	90	24D
0005435884421	8323	91	24C
0005435884419	8323	92	24E
0005435884395	8323	93	25B
0005432459004	8323	94	25A
0005432458976	8323	95	25D
0005432458961	8323	96	25C
0005432459009	8323	97	25E
0005435884413	8323	98	25F
0005435884423	8323	99	26B
0005432458989	8323	100	26A
0005432042474	8323	101	26C
0005432458987	8323	102	26E
0005435884387	8323	103	26F
0005432458969	8323	104	27C
0005435884376	8323	105	27D
0005432459002	8323	106	27F
0005432458957	8323	107	27E
0005435884406	8323	108	28C
0005435884399	8323	109	28B
0005432459007	8323	110	28A
0005432042480	8323	111	28E
0005432458998	8323	112	29A
0005432458981	8323	113	29C
0005432458958	8323	114	29B
0005432458959	8323	115	29D
0005432458982	8323	116	29F
0005432042470	8323	117	29E
0005435884379	8323	118	30A
0005432042468	8323	119	30B
0005435884392	8323	120	30C
0005435884380	8323	121	30E
0005432042477	8323	122	30D
0005432458986	8323	123	31C
0005432458994	8323	124	31D
0005435884403	8323	125	31F
0005435884388	8323	126	31E
0005432382506	4522	1	1A
0005432382517	4522	2	1F
0005432727721	4522	3	3A
0005432382485	4522	4	3C
0005432382509	4522	5	3D
0005432382488	4522	6	3F
0005432727716	4522	7	4A
0005432727720	4522	8	5A
0005433722105	4522	9	5D
0005432382501	4522	10	5E
0005432382505	4522	11	5F
0005432382511	4522	12	6C
0005432382500	4522	13	6E
0005432727722	4522	14	7A
0005432382495	4522	15	7F
0005432382508	4522	16	8A
0005432727727	4522	17	8C
0005432382492	4522	18	8D
0005432727725	4522	19	9C
0005432382497	4522	20	9D
0005432382486	4522	21	9F
0005432382512	4522	22	10C
0005432382507	4522	23	10D
0005432382493	4522	24	10F
0005433722106	4522	25	11A
0005432382514	4522	26	11C
0005433722103	4522	27	11D
0005432382484	4522	28	11F
0005432382502	4522	29	12A
0005432382499	4522	30	12C
0005432382519	4522	31	12F
0005432382503	4522	32	13C
0005432382504	4522	33	13D
0005433722104	4522	34	13F
0005433453727	4522	35	14A
0005432382510	4522	36	14C
0005432727719	4522	37	14E
0005432727718	4522	38	14F
0005432382498	4522	39	15A
0005433722102	4522	40	15C
0005432382496	4522	41	15D
0005432382487	4522	42	15E
0005432382516	4522	43	15F
0005432727717	4522	44	16A
0005432727723	4522	45	16C
0005432382518	4522	46	16F
0005432382490	4522	47	17A
0005433454838	4522	48	17C
0005432382489	4522	49	17F
0005432727724	4522	50	18A
0005433453726	4522	51	18C
0005432727726	4522	52	19C
0005432382494	4522	53	19D
0005432382515	4522	54	19E
0005433454837	4522	55	19F
0005432382513	4522	56	20A
0005432382491	4522	57	20D
0005432382520	4522	58	20E
0005435528884	1764	1	1C
0005433516726	1764	2	1D
0005432294445	1764	3	1F
0005435540628	1764	4	2C
0005435528879	1764	5	2F
0005435528885	1764	6	3A
0005435528896	1764	7	3C
0005435540640	1764	8	4E
0005435540625	1764	9	5C
0005435540639	1764	10	5D
0005435540638	1764	11	5E
0005435540630	1764	12	5F
0005435528894	1764	13	6D
0005435540627	1764	14	6E
0005435528893	1764	15	6F
0005435540633	1764	16	7A
0005435528898	1764	17	7D
0005435540635	1764	18	7E
0005435528891	1764	19	7F
0005433516727	1764	20	8C
0005435540643	1764	21	8F
0005435540641	1764	22	9A
0005435540634	1764	23	9C
0005435540632	1764	24	9E
0005435528880	1764	25	9F
0005433516722	1764	26	10A
0005435528887	1764	27	10C
0005435540629	1764	28	10E
0005435528883	1764	29	10F
0005435528881	1764	30	11A
0005435528882	1764	31	11C
0005435540631	1764	32	11E
0005435540623	1764	33	12C
0005433516729	1764	34	13A
0005435540637	1764	35	13D
0005435528895	1764	36	13E
0005433516721	1764	37	14A
0005435528899	1764	38	14C
0005435540642	1764	39	14D
0005435528892	1764	40	14E
0005435528900	1764	41	15A
0005435540636	1764	42	15C
0005432294446	1764	43	15D
0005435528886	1764	44	15E
0005435540626	1764	45	15F
0005433516723	1764	46	16E
0005435540622	1764	47	16F
0005435528890	1764	48	17E
0005435540624	1764	49	17F
0005433516725	1764	50	18A
0005433516724	1764	51	18C
0005435528888	1764	52	20A
0005435528889	1764	53	20C
0005435528897	1764	54	20D
0005433516728	1764	55	20F
0005432924953	21969	1	6A
0005432924951	21969	2	9E
0005432924955	21969	3	12D
0005432924952	21969	4	14D
0005432924954	21969	5	15E
0005434458440	7364	1	1A
0005432838490	7364	2	1C
0005432838492	7364	3	1F
0005434458439	7364	4	2A
0005432838507	7364	5	2C
0005432838495	7364	6	4C
0005434458449	7364	7	4D
0005434458437	7364	8	4E
0005434458448	7364	9	5E
0005432838510	7364	10	5F
0005432838488	7364	11	6A
0005432073330	7364	12	6E
0005434458433	7364	13	6F
0005434458436	7364	14	7A
0005432838505	7364	15	7E
0005434458450	7364	16	7F
0005432838498	7364	17	8A
0005434458452	7364	18	8C
0005434458434	7364	19	8D
0005432838509	7364	20	8E
0005432838497	7364	21	9D
0005432073331	7364	22	9E
0005434458443	7364	23	10A
0005432838496	7364	24	10C
0005432838484	7364	25	10E
0005434458453	7364	26	11D
0005432838489	7364	27	11E
0005432838487	7364	28	12C
0005432838480	7364	29	12E
0005434458435	7364	30	12F
0005434458438	7364	31	13A
0005434458442	7364	32	13D
0005434458451	7364	33	13F
0005432838499	7364	34	14A
0005432073329	7364	35	14C
0005432838481	7364	36	14D
0005432838483	7364	37	14E
0005432838503	7364	38	14F
0005432838511	7364	39	15C
0005432838485	7364	40	15D
0005434458441	7364	41	15E
0005432838501	7364	42	15F
0005434458447	7364	43	17A
0005432838482	7364	44	17D
0005434458444	7364	45	17C
0005432838502	7364	46	17E
0005432838486	7364	47	18C
0005434458445	7364	48	18D
0005432838508	7364	49	18E
0005432838500	7364	50	19C
0005434458446	7364	51	19D
0005432838493	7364	52	19E
0005432838491	7364	53	20C
0005432838506	7364	54	20D
0005432838494	7364	55	20E
0005432838504	7364	56	20F
0005435252378	28935	1	1A
0005435252382	28935	2	1D
0005435252385	28935	3	2C
0005435252379	28935	4	2D
0005435252390	28935	5	3A
0005435252381	28935	6	4E
0005435252396	28935	7	5C
0005435491407	28935	8	6A
0005435252383	28935	9	6D
0005432000987	28935	10	7A
0005435252393	28935	11	8A
0005435252392	28935	12	9F
0005435252388	28935	13	10A
0005432000988	28935	14	10E
0005434664920	28935	15	11D
0005435252380	28935	16	11F
0005434664919	28935	17	14F
0005435252384	28935	18	15C
0005435252389	28935	19	16A
0005435252395	28935	20	18A
0005435491405	28935	21	18D
0005435491406	28935	22	18E
0005435252391	28935	23	19E
0005435252387	28935	24	19F
0005435252394	28935	25	20E
0005435252386	28935	26	20F
0005435990502	8817	1	3A
0005435990497	8817	2	6B
0005435990498	8817	3	6D
0005435990503	8817	4	7E
0005435990501	8817	5	13B
0005435990499	8817	6	14C
0005435990500	8817	7	20B
0005434275928	15750	1	1F
0005434275925	15750	2	11C
0005434275926	15750	3	11D
0005434275924	15750	4	18A
0005434275927	15750	5	20D
0005433468183	2079	1	1D
0005433468182	2079	2	3B
0005433468185	2079	3	5D
0005433468184	2079	4	7C
0005433468181	2079	5	20C
0005433468186	2079	6	21C
0005433468180	2079	7	22D
0005433468187	2079	8	23A
0005433468188	2079	9	23B
0005432359506	6411	1	1A
0005432062135	6411	2	1F
0005432359555	6411	3	2C
0005432359536	6411	4	2D
0005432335821	6411	5	3C
0005432335824	6411	6	3A
0005432359533	6411	7	3F
0005432359552	6411	8	4B
0005432359525	6411	9	4E
0005432335829	6411	10	4D
0005432359537	6411	11	5B
0005432359513	6411	12	5C
0005432359521	6411	13	6C
0005432062136	6411	14	6B
0005432359527	6411	15	6D
0005432335825	6411	16	7D
0005432359540	6411	17	7E
0005432335822	6411	18	8A
0005432359544	6411	19	8C
0005432363360	6411	20	8E
0005432359507	6411	21	8F
0005432359550	6411	22	9B
0005432335823	6411	23	9C
0005432359529	6411	24	9F
0005432359543	6411	25	10B
0005432359511	6411	26	10E
0005432359528	6411	27	11D
0005432359551	6411	28	11F
0005432359522	6411	29	12B
0005432359547	6411	30	12D
0005432359510	6411	31	12C
0005432359532	6411	32	12E
0005432359524	6411	33	12F
0005432359508	6411	34	13A
0005432359541	6411	35	13B
0005432359542	6411	36	13D
0005432335827	6411	37	13E
0005432359512	6411	38	13F
0005432359518	6411	39	14A
0005432359517	6411	40	14C
0005432359548	6411	41	14F
0005432062134	6411	42	15B
0005432062137	6411	43	15D
0005432363359	6411	44	15E
0005432335820	6411	45	16A
0005432359519	6411	46	15F
0005432359539	6411	47	16B
0005432359554	6411	48	16E
0005432359534	6411	49	16F
0005432062139	6411	50	17A
0005432335826	6411	51	17E
0005432335830	6411	52	18A
0005432359530	6411	53	17F
0005432335831	6411	54	18B
0005432335828	6411	55	18D
0005432062138	6411	56	18C
0005432359526	6411	57	18F
0005432359520	6411	58	19C
0005432359545	6411	59	20B
0005432359531	6411	60	20C
0005432359515	6411	61	20E
0005432359514	6411	62	21B
0005432359523	6411	63	21F
0005432359538	6411	64	22A
0005432359546	6411	65	22B
0005432359535	6411	66	22E
0005432359553	6411	67	23A
0005432359549	6411	68	22F
0005432359516	6411	69	23B
0005432359509	6411	70	23C
0005435176585	20993	1	1C
0005435723010	20993	2	2A
0005434149526	20993	3	3C
0005435176587	20993	4	4B
0005435176608	20993	5	4E
0005434149522	20993	6	4F
0005435176610	20993	7	5C
0005435176594	20993	8	5F
0005435176612	20993	9	5E
0005435723009	20993	10	6D
0005435176601	20993	11	7B
0005435176603	20993	12	8A
0005435176596	20993	13	7F
0005432052694	20993	14	8C
0005435176602	20993	15	8F
0005434149529	20993	16	9A
0005432052692	20993	17	9B
0005435176590	20993	18	9C
0005435176600	20993	19	9E
0005434149521	20993	20	9D
0005435176588	20993	21	9F
0005435176599	20993	22	10B
0005434149528	20993	23	10C
0005435490169	20993	24	10E
0005432052693	20993	25	11A
0005434149530	20993	26	11E
0005435176592	20993	27	11F
0005435176593	20993	28	12B
0005432052691	20993	29	12C
0005435176609	20993	30	13D
0005435176597	20993	31	13E
0005435490172	20993	32	14D
0005435176604	20993	33	14E
0005434149531	20993	34	14F
0005435176591	20993	35	15C
0005435176589	20993	36	15B
0005434149527	20993	37	16A
0005435176586	20993	38	15F
0005435176611	20993	39	17A
0005435176598	20993	40	17B
0005435176607	20993	41	18A
0005434149525	20993	42	18B
0005435176605	20993	43	18E
0005435176595	20993	44	19A
0005435490173	20993	45	19B
0005435176606	20993	46	19E
0005434149523	20993	47	22D
0005435490170	20993	48	22F
0005434149520	20993	49	23A
0005435490171	20993	50	23B
0005434149524	20993	51	23E
0005434186148	17732	1	4D
0005434186147	17732	2	7D
0005434186149	17732	3	20A
0005434458435	29107	1	1A
0005434458448	29107	2	2A
0005434458445	29107	3	2C
0005434458442	29107	4	3A
0005434458446	29107	5	3C
0005434458449	29107	6	4A
0005434458452	29107	7	4C
0005434458437	29107	8	5C
0005434458450	29107	9	5D
0005434458440	29107	10	6A
0005434458453	29107	11	6B
0005434458447	29107	12	7C
0005434458444	29107	13	7D
0005434458451	29107	14	18B
0005434458433	29107	15	19B
0005434458439	29107	16	20D
0005434458434	29107	17	21B
0005434458441	29107	18	22A
0005434458438	29107	19	22B
0005434458436	29107	20	22C
0005434458443	29107	21	22D
0005435221036	31696	1	1B
0005435221035	31696	2	1C
0005435221497	31696	3	2A
0005433293144	29590	1	2D
0005433293143	29590	2	7A
0005433293145	29590	3	18A
0005433293142	29590	4	18D
0005433293146	29590	5	20C
0005433293147	29590	6	21C
0005433473104	6691	1	2A
0005433473108	6691	2	3B
0005433473101	6691	3	4A
0005433473107	6691	4	6A
0005433473103	6691	5	6B
0005433473106	6691	6	18A
0005433473105	6691	7	21B
0005433473102	6691	8	22C
0005433473100	6691	9	23A
0005432746899	370	1	1A
0005432746871	370	2	1D
0005432746901	370	3	1F
0005432746867	370	4	2C
0005432746878	370	5	3C
0005432746869	370	6	4A
0005432746898	370	7	4C
0005432746876	370	8	4D
0005432746886	370	9	4F
0005432746872	370	10	5A
0005432746880	370	11	5C
0005432746896	370	12	5E
0005432746893	370	13	5F
0005432219928	370	14	6E
0005432746883	370	15	7A
0005432219929	370	16	7D
0005432746891	370	17	7E
0005432746902	370	18	8C
0005432746875	370	19	8D
0005432746887	370	20	9C
0005432746900	370	21	10E
0005432746895	370	22	10F
0005432746865	370	23	11A
0005432746866	370	24	11E
0005432746884	370	25	11F
0005432746889	370	26	12C
0005432746888	370	27	12D
0005432746873	370	28	12F
0005432746890	370	29	13F
0005432746877	370	30	14C
0005432746879	370	31	14E
0005432746868	370	32	14F
0005432746874	370	33	16D
0005432746892	370	34	16E
0005432219926	370	35	17C
0005432746881	370	36	17E
0005432746864	370	37	17F
0005432746897	370	38	18C
0005432746870	370	39	19C
0005432746882	370	40	19D
0005432219927	370	41	19E
0005432746885	370	42	20C
0005432746894	370	43	20F
0005432890687	12076	1	1A
0005432890680	12076	2	1C
0005432890679	12076	3	2A
0005432214765	12076	4	2D
0005432890686	12076	5	3D
0005432890688	12076	6	4F
0005432214766	12076	7	5F
0005432214764	12076	8	6C
0005432890670	12076	9	8C
0005433875352	12076	10	8F
0005432890675	12076	11	10F
0005432890671	12076	12	11E
0005432890689	12076	13	12E
0005432890672	12076	14	13C
0005432890677	12076	15	13D
0005432890678	12076	16	14D
0005432890674	12076	17	15D
0005432890683	12076	18	16C
0005432890669	12076	19	17C
0005432890673	12076	20	17E
0005432890682	12076	21	17F
0005432890684	12076	22	18D
0005432890681	12076	23	18E
0005432890676	12076	24	19D
0005432890685	12076	25	20F
0005432927886	32474	1	6A
0005432927885	32474	2	6B
0005432927888	32474	3	20C
0005432927889	32474	4	22A
0005432927887	32474	5	22B
0005434821383	5254	1	1C
0005434821405	5254	2	1G
0005432396171	5254	3	2A
0005434821341	5254	4	2H
0005434821329	5254	5	3G
0005434821353	5254	6	3C
0005434821372	5254	7	4C
0005434821375	5254	8	4A
0005434821347	5254	9	4G
0005435149796	5254	10	4H
0005432394035	5254	11	5C
0005434821390	5254	12	5A
0005432121094	5254	13	5H
0005434821349	5254	14	11A
0005434821389	5254	15	11F
0005434821357	5254	16	11K
0005434821364	5254	17	11H
0005434821323	5254	18	12G
0005434821419	5254	19	12F
0005434821348	5254	20	13H
0005434821345	5254	21	13G
0005434821358	5254	22	14A
0005434821346	5254	23	13K
0005432394033	5254	24	14C
0005434821438	5254	25	14G
0005434821382	5254	26	14F
0005434821338	5254	27	15A
0005434821437	5254	28	14K
0005434821377	5254	29	15F
0005432121085	5254	30	16A
0005434821325	5254	31	15K
0005434821340	5254	32	15H
0005434821411	5254	33	16D
0005434821367	5254	34	16C
0005432121090	5254	35	16F
0005432121087	5254	36	16H
0005434821426	5254	37	16G
0005434821337	5254	38	17D
0005434821397	5254	39	17G
0005434821417	5254	40	17F
0005434821392	5254	41	17H
0005434821363	5254	42	18E
0005434821343	5254	43	18C
0005434821321	5254	44	18J
0005434821332	5254	45	19C
0005434821386	5254	46	19E
0005434821312	5254	47	20C
0005434821422	5254	48	21B
0005434821391	5254	49	21A
0005434821316	5254	50	21D
0005434821339	5254	51	21F
0005434821378	5254	52	21E
0005434821376	5254	53	21J
0005434821314	5254	54	21H
0005432396173	5254	55	21K
0005434821430	5254	56	22D
0005434821388	5254	57	22E
0005434821423	5254	58	22K
0005434821407	5254	59	23A
0005434821395	5254	60	23F
0005434821311	5254	61	23E
0005432121088	5254	62	25B
0005434821355	5254	63	25A
0005434821393	5254	64	25D
0005434821374	5254	65	25C
0005434821327	5254	66	25F
0005434821399	5254	67	25G
0005435149793	5254	68	25K
0005434821334	5254	69	26E
0005434821400	5254	70	26G
0005432396170	5254	71	27B
0005435149788	5254	72	27F
0005434821403	5254	73	27J
0005434821387	5254	74	28B
0005434821354	5254	75	28E
0005434821416	5254	76	28D
0005434821342	5254	77	28F
0005434821320	5254	78	29B
0005434821352	5254	79	29E
0005434821414	5254	80	29H
0005434821396	5254	81	29K
0005434821381	5254	82	29J
0005434821429	5254	83	30A
0005434821409	5254	84	30E
0005435149792	5254	85	30H
0005434821428	5254	86	30G
0005434821319	5254	87	31A
0005434821362	5254	88	31D
0005432121092	5254	89	31C
0005435149785	5254	90	31E
0005432394034	5254	91	31H
0005434821356	5254	92	32A
0005434821333	5254	93	32H
0005434821315	5254	94	33D
0005434821326	5254	95	33C
0005434821368	5254	96	33J
0005432121084	5254	97	33H
0005435149797	5254	98	33K
0005435149789	5254	99	34C
0005434821394	5254	100	34E
0005434821418	5254	101	34D
0005434821318	5254	102	34K
0005434821384	5254	103	35A
0005434821415	5254	104	35E
0005434821361	5254	105	35J
0005434821317	5254	106	35G
0005434821370	5254	107	36F
0005432394032	5254	108	36D
0005434821408	5254	109	37D
0005434821335	5254	110	37F
0005434821425	5254	111	37H
0005434821406	5254	112	37K
0005435149786	5254	113	38C
0005434821410	5254	114	38A
0005434821421	5254	115	38J
0005435149795	5254	116	39F
0005434821371	5254	117	40A
0005434821366	5254	118	39K
0005434821433	5254	119	40D
0005432121091	5254	120	40F
0005434821435	5254	121	40J
0005432121083	5254	122	40K
0005434821336	5254	123	41D
0005435149794	5254	124	41C
0005434821344	5254	125	41G
0005434821385	5254	126	41E
0005434821432	5254	127	41H
0005432121095	5254	128	42C
0005434821412	5254	129	42B
0005434821398	5254	130	42A
0005434821427	5254	131	42D
0005434821420	5254	132	43F
0005432396174	5254	133	43H
0005435149790	5254	134	43G
0005434821413	5254	135	43K
0005434821328	5254	136	44A
0005432121089	5254	137	44E
0005434821330	5254	138	44F
0005434821369	5254	139	44J
0005434821434	5254	140	44H
0005434821436	5254	141	45B
0005432396172	5254	142	45A
0005434821404	5254	143	45C
0005434821380	5254	144	45D
0005434821401	5254	145	45G
0005432121086	5254	146	45K
0005434821379	5254	147	45J
0005434821313	5254	148	46B
0005434821351	5254	149	46G
0005434821365	5254	150	46F
0005434821439	5254	151	46H
0005435149787	5254	152	47E
0005432121093	5254	153	47F
0005434821373	5254	154	47K
0005434821331	5254	155	47H
0005434821424	5254	156	48D
0005434821359	5254	157	48C
0005434821431	5254	158	48K
0005434821322	5254	159	49D
0005435149791	5254	160	49C
0005434821402	5254	161	50D
0005434821350	5254	162	50F
0005434821324	5254	163	51D
0005434821360	5254	164	50H
0005435372151	9891	1	2C
0005435372158	9891	2	2G
0005435735057	9891	3	2K
0005435372150	9891	4	3K
0005435372145	9891	5	5H
0005435372110	9891	6	11D
0005435372100	9891	7	11G
0005435372147	9891	8	12C
0005435372157	9891	9	12D
0005435372149	9891	10	13C
0005435372125	9891	11	13H
0005435372107	9891	12	14E
0005435372097	9891	13	14D
0005432202939	9891	14	14G
0005435386455	9891	15	14K
0005435661881	9891	16	15F
0005435372132	9891	17	15K
0005435372140	9891	18	16D
0005435372103	9891	19	16C
0005435372154	9891	20	16G
0005432202933	9891	21	17E
0005435372104	9891	22	17F
0005435372102	9891	23	18B
0005432202936	9891	24	18H
0005435372094	9891	25	19C
0005435372142	9891	26	19E
0005435372136	9891	27	19J
0005435661880	9891	28	21B
0005435735055	9891	29	21G
0005435386456	9891	30	22C
0005435372115	9891	31	22E
0005432823415	9891	32	22G
0005435372105	9891	33	22K
0005435372121	9891	34	24F
0005435372144	9891	35	25A
0005435372114	9891	36	25C
0005435372153	9891	37	25B
0005435372137	9891	38	25E
0005432202940	9891	39	27D
0005435372106	9891	40	27E
0005435372113	9891	41	27G
0005435372143	9891	42	28D
0005435372129	9891	43	29C
0005435661879	9891	44	30C
0005435372099	9891	45	31K
0005435372133	9891	46	32C
0005435372123	9891	47	32B
0005435372126	9891	48	32G
0005435372118	9891	49	33D
0005435372127	9891	50	33C
0005435372130	9891	51	33E
0005432202938	9891	52	34D
0005435372098	9891	53	34G
0005435372096	9891	54	34F
0005435735059	9891	55	35B
0005435372122	9891	56	35A
0005435735056	9891	57	35D
0005432202937	9891	58	36D
0005435372138	9891	59	36B
0005435372124	9891	60	36H
0005435372156	9891	61	37A
0005435372109	9891	62	37G
0005435735058	9891	63	37F
0005435372152	9891	64	39C
0005435372141	9891	65	39G
0005435372095	9891	66	41E
0005432202935	9891	67	42D
0005435372131	9891	68	42F
0005435372146	9891	69	42K
0005435372134	9891	70	43A
0005435372117	9891	71	43D
0005435372128	9891	72	44E
0005435372112	9891	73	45A
0005435372116	9891	74	45C
0005435372101	9891	75	46C
0005435372155	9891	76	46D
0005435372135	9891	77	47A
0005432202934	9891	78	47G
0005435386457	9891	79	47E
0005435372139	9891	80	47H
0005435386454	9891	81	48G
0005435372119	9891	82	49C
0005435372120	9891	83	49G
0005435372148	9891	84	50A
0005435372111	9891	85	50G
0005435372108	9891	86	50K
0005435082647	6978	1	1B
0005435082645	6978	2	2C
0005435082646	6978	3	5A
0005435790256	6978	4	6A
0005435790255	6978	5	18B
0005435082644	6978	6	19C
0005435082643	6978	7	21A
0005435082649	6978	8	22B
0005435082648	6978	9	22C
0005434755729	9528	1	1C
0005434755725	9528	2	1F
0005434755717	9528	3	2A
0005434755712	9528	4	2F
0005434755709	9528	5	3F
0005434755720	9528	6	4A
0005434755719	9528	7	4E
0005434755710	9528	8	5A
0005434755721	9528	9	5C
0005434755724	9528	10	5F
0005434755728	9528	11	6A
0005434755708	9528	12	6F
0005434755735	9528	13	7A
0005434755705	9528	14	7D
0005434755704	9528	15	8D
0005434755711	9528	16	9E
0005434755718	9528	17	9D
0005434755715	9528	18	9F
0005434755727	9528	19	10D
0005434755706	9528	20	11D
0005434755716	9528	21	12D
0005434755732	9528	22	12E
0005434755713	9528	23	13D
0005434755734	9528	24	14A
0005434755730	9528	25	15C
0005434755723	9528	26	16E
0005434755707	9528	27	16F
0005434755703	9528	28	17D
0005434755714	9528	29	17E
0005434755731	9528	30	18E
0005434755726	9528	31	18F
0005434755733	9528	32	19E
0005434755722	9528	33	20E
0005435100070	10806	1	7B
0005435100071	10806	2	18A
0005435100069	10806	3	21B
0005434760153	31815	1	6C
0005434760155	31815	2	19D
0005434760154	31815	3	20D
0005434638861	1994	1	1A
0005434638852	1994	2	1B
0005434638867	1994	3	1C
0005434638851	1994	4	2A
0005432290582	1994	5	2C
0005434638858	1994	6	2D
0005434638875	1994	7	3A
0005434638868	1994	8	3B
0005434638846	1994	9	3C
0005434638849	1994	10	3D
0005434638865	1994	11	4C
0005434638869	1994	12	4D
0005434638873	1994	13	5B
0005434638855	1994	14	5C
0005432290579	1994	15	6A
0005435948304	1994	16	6B
0005432290581	1994	17	6C
0005434638853	1994	18	6D
0005434638866	1994	19	7B
0005434638872	1994	20	7D
0005434638862	1994	21	18A
0005434638863	1994	22	18B
0005434638854	1994	23	19A
0005434638871	1994	24	19B
0005434638850	1994	25	19D
0005435948306	1994	26	20B
0005434638860	1994	27	20C
0005432290580	1994	28	20D
0005434638856	1994	29	21A
0005434638848	1994	30	21B
0005434638857	1994	31	21C
0005434638847	1994	32	21D
0005434638864	1994	33	22B
0005435948305	1994	34	22A
0005434638859	1994	35	22C
0005434638870	1994	36	22D
0005434638874	1994	37	23B
0005434600341	6050	1	1A
0005434600351	6050	2	1C
0005434600342	6050	3	1F
0005433531228	6050	4	2A
0005434600333	6050	5	2C
0005433531225	6050	6	2F
0005433533242	6050	7	3A
0005434600346	6050	8	3D
0005434600336	6050	9	3F
0005434600338	6050	10	4A
0005434600349	6050	11	4E
0005434600331	6050	12	5F
0005434600340	6050	13	6F
0005432111226	6050	14	7D
0005434600332	6050	15	7F
0005433533241	6050	16	8F
0005433531226	6050	17	9E
0005434600337	6050	18	10C
0005434600343	6050	19	11C
0005434600329	6050	20	11F
0005433533240	6050	21	12C
0005434600353	6050	22	12D
0005434600334	6050	23	13D
0005434600328	6050	24	13E
0005433533243	6050	25	15A
0005432111227	6050	26	15D
0005434600330	6050	27	15E
0005434600339	6050	28	15F
0005433531227	6050	29	16C
0005434600350	6050	30	17A
0005434600345	6050	31	17E
0005434600344	6050	32	18A
0005434600352	6050	33	18D
0005434600347	6050	34	18F
0005434600348	6050	35	18E
0005434600335	6050	36	19C
0005432111225	6050	37	19D
0005434600327	6050	38	20D
0005435326511	18571	1	2C
0005435326498	18571	2	4D
0005435326500	18571	3	4F
0005435326507	18571	4	6E
0005435326510	18571	5	9C
0005435326497	18571	6	11A
0005435326506	18571	7	13C
0005435326501	18571	8	14D
0005435326509	18571	9	15F
0005435326499	18571	10	16A
0005435326504	18571	11	16C
0005435326505	18571	12	18E
0005435326502	18571	13	19C
0005435326503	18571	14	19F
0005435326508	18571	15	20D
0005434554024	10653	1	15C
0005433180671	27692	1	1A
0005433180663	27692	2	2D
0005433180665	27692	3	2F
0005433180648	27692	4	3A
0005433180649	27692	5	3D
0005433180661	27692	6	3F
0005433180650	27692	7	4E
0005433180667	27692	8	5D
0005433180662	27692	9	6E
0005433180659	27692	10	7A
0005433180672	27692	11	6F
0005433180670	27692	12	7C
0005433180657	27692	13	7F
0005433180652	27692	14	8A
0005433180656	27692	15	10D
0005433180673	27692	16	10F
0005433180655	27692	17	11C
0005433180654	27692	18	11E
0005433180658	27692	19	12A
0005433180666	27692	20	12C
0005433180660	27692	21	13D
0005433180664	27692	22	13E
0005433180653	27692	23	14C
0005433180651	27692	24	14E
0005433180668	27692	25	16F
0005433180669	27692	26	20C
0005433459143	6148	1	1B
0005433459145	6148	2	2B
0005433459146	6148	3	5A
0005433459144	6148	4	6B
0005435254429	19301	1	2B
0005435254430	19301	2	6A
0005435681419	6733	1	1A
0005435681402	6733	2	1F
0005432136082	6733	3	2A
0005435681386	6733	4	2C
0005432136083	6733	5	2F
0005435681404	6733	6	3A
0005435681421	6733	7	4A
0005435681423	6733	8	4E
0005435681425	6733	9	5A
0005435681403	6733	10	5D
0005435681390	6733	11	6A
0005435681408	6733	12	6C
0005435720118	6733	13	6D
0005435681384	6733	14	6E
0005435681422	6733	15	6F
0005432136081	6733	16	7A
0005435681411	6733	17	7C
0005435681392	6733	18	7E
0005435681389	6733	19	8A
0005435681401	6733	20	8D
0005435681385	6733	21	8E
0005435681415	6733	22	8F
0005435681395	6733	23	9A
0005435681396	6733	24	9C
0005435681399	6733	25	9F
0005435681410	6733	26	10C
0005435681391	6733	27	10E
0005435681414	6733	28	11A
0005435681420	6733	29	11E
0005432136079	6733	30	12C
0005435681417	6733	31	12D
0005435720119	6733	32	13A
0005432136084	6733	33	13D
0005435681407	6733	34	13E
0005435681427	6733	35	14D
0005435681393	6733	36	14E
0005435681405	6733	37	14F
0005432136080	6733	38	15A
0005435681394	6733	39	15D
0005435681397	6733	40	16A
0005435681426	6733	41	16C
0005435681387	6733	42	17C
0005435681424	6733	43	17D
0005435681388	6733	44	18C
0005435681413	6733	45	18D
0005435681409	6733	46	18E
0005435681412	6733	47	18F
0005435681400	6733	48	19F
0005435681398	6733	49	20A
0005435681418	6733	50	20C
0005435681406	6733	51	20D
0005435681416	6733	52	20F
0005435437570	24574	1	1C
0005435437562	24574	2	2C
0005435437557	24574	3	2D
0005435437568	24574	4	3C
0005435437573	24574	5	3D
0005432533240	24574	6	4C
0005435437566	24574	7	4D
0005435437574	24574	8	5D
0005432305706	24574	9	6A
0005434828649	24574	10	6C
0005435437563	24574	11	6E
0005435437567	24574	12	6F
0005435437569	24574	13	7E
0005435437572	24574	14	7F
0005435437559	24574	15	8A
0005435437551	24574	16	8C
0005435437553	24574	17	9C
0005434828650	24574	18	9E
0005435437560	24574	19	9F
0005434828648	24574	20	10A
0005435437554	24574	21	11A
0005432305705	24574	22	11D
0005435437564	24574	23	12E
0005435437571	24574	24	15D
0005432533241	24574	25	16D
0005435437555	24574	26	17C
0005435437565	24574	27	18D
0005435437558	24574	28	18F
0005432533242	24574	29	19F
0005435437556	24574	30	20C
0005435437561	24574	31	20E
0005435437552	24574	32	20F
0005435105923	11521	1	14E
0005435105925	11521	2	18E
0005435105924	11521	3	20A
0005435558039	31901	1	4C
0005435558040	31901	2	7D
0005435558041	31901	3	18F
0005433397181	13537	1	1F
0005433397182	13537	2	2A
0005433397222	13537	3	3C
0005433397212	13537	4	3D
0005433397220	13537	5	3F
0005433397200	13537	6	4A
0005433397203	13537	7	4C
0005433397184	13537	8	4E
0005433397179	13537	9	6D
0005433397188	13537	10	6E
0005433397202	13537	11	6F
0005433397196	13537	12	7D
0005433397213	13537	13	7E
0005433397201	13537	14	8C
0005433397224	13537	15	8D
0005433397207	13537	16	8E
0005433397197	13537	17	9A
0005433397208	13537	18	9E
0005433397183	13537	19	9F
0005433397205	13537	20	10C
0005433397187	13537	21	10D
0005433397211	13537	22	10F
0005433397228	13537	23	11C
0005433397217	13537	24	11D
0005433397194	13537	25	11F
0005433397214	13537	26	12E
0005433397189	13537	27	12F
0005433397215	13537	28	13D
0005433397226	13537	29	13F
0005433397225	13537	30	14A
0005433397216	13537	31	14D
0005433397227	13537	32	14F
0005433397223	13537	33	15C
0005433397185	13537	34	15D
0005433397198	13537	35	15E
0005433397192	13537	36	15F
0005433397219	13537	37	16A
0005433397210	13537	38	16C
0005433397178	13537	39	16D
0005433397206	13537	40	16F
0005433397180	13537	41	17A
0005433397193	13537	42	17D
0005433397218	13537	43	17E
0005433397191	13537	44	18A
0005433397221	13537	45	18C
0005433397199	13537	46	18E
0005433397186	13537	47	19D
0005433397209	13537	48	20A
0005433397190	13537	49	20C
0005433397195	13537	50	20D
0005433397204	13537	51	20F
0005435732116	19417	1	1C
0005435732122	19417	2	2A
0005435732117	19417	3	3A
0005435732114	19417	4	3C
0005435732121	19417	5	4E
0005432297231	19417	6	5A
0005435732119	19417	7	5F
0005435732112	19417	8	8A
0005435732115	19417	9	10F
0005435732123	19417	10	11D
0005432297232	19417	11	13C
0005435732120	19417	12	13E
0005432297230	19417	13	16C
0005435732113	19417	14	16D
0005435732124	19417	15	17D
0005435732118	19417	16	20E
0005435925055	13148	1	2D
0005435925051	13148	2	2F
0005435925047	13148	3	3C
0005435925054	13148	4	5D
0005435925060	13148	5	6F
0005435925049	13148	6	7A
0005435925057	13148	7	7E
0005435925048	13148	8	8A
0005435925052	13148	9	10F
0005435925050	13148	10	12C
0005435925046	13148	11	14F
0005435925058	13148	12	15D
0005435925059	13148	13	15E
0005435925053	13148	14	18F
0005435925056	13148	15	20D
0005433407477	29499	1	1C
0005433407479	29499	2	4D
0005433407478	29499	3	6A
0005433407480	29499	4	20A
0005433407481	29499	5	21B
0005434213729	10699	1	1A
0005434213726	10699	2	1D
0005434213707	10699	3	2A
0005434213720	10699	4	2C
0005434213731	10699	5	3D
0005434213728	10699	6	4A
0005434213740	10699	7	4D
0005434213705	10699	8	4F
0005434213704	10699	9	5C
0005434213702	10699	10	6A
0005434213737	10699	11	6F
0005434213708	10699	12	7A
0005434213732	10699	13	7C
0005434213712	10699	14	7F
0005434213724	10699	15	8A
0005434213743	10699	16	8D
0005434213742	10699	17	8E
0005434213701	10699	18	9A
0005434213709	10699	19	10A
0005434213698	10699	20	10C
0005434213714	10699	21	10D
0005434213717	10699	22	10F
0005434213733	10699	23	11C
0005434213703	10699	24	11D
0005434213734	10699	25	11E
0005434213721	10699	26	11F
0005434213715	10699	27	12C
0005434213713	10699	28	13D
0005434213718	10699	29	13F
0005434213723	10699	30	14D
0005434213711	10699	31	15A
0005434213735	10699	32	15D
0005434213716	10699	33	15E
0005434213744	10699	34	16C
0005434213727	10699	35	16E
0005434213700	10699	36	16F
0005434213719	10699	37	17D
0005434213738	10699	38	17E
0005434213706	10699	39	18A
0005434213736	10699	40	18C
0005434213730	10699	41	18D
0005434213710	10699	42	18E
0005434213741	10699	43	19D
0005434213739	10699	44	19E
0005434213745	10699	45	19F
0005434213725	10699	46	20D
0005434213699	10699	47	20E
0005434213722	10699	48	20F
0005435006602	5474	1	1A
0005432125319	5474	2	1C
0005435038610	5474	3	1D
0005435006618	5474	4	1F
0005435006616	5474	5	2A
0005432125321	5474	6	2D
0005435038645	5474	7	2F
0005435006611	5474	8	3D
0005435038638	5474	9	3F
0005432125324	5474	10	4A
0005435038661	5474	11	4D
0005435038618	5474	12	4C
0005435006606	5474	13	4E
0005435038631	5474	14	4F
0005435006610	5474	15	5B
0005435038643	5474	16	5A
0005435038627	5474	17	5C
0005432125322	5474	18	5D
0005435038656	5474	19	5F
0005435006607	5474	20	6B
0005435038668	5474	21	6F
0005435038619	5474	22	6E
0005435038648	5474	23	7A
0005435038611	5474	24	7C
0005435038642	5474	25	7B
0005435038652	5474	26	7E
0005435038665	5474	27	8A
0005435038626	5474	28	7F
0005435038666	5474	29	8B
0005435006603	5474	30	8C
0005435038672	5474	31	8D
0005435038675	5474	32	8F
0005435038662	5474	33	8E
0005435038659	5474	34	9A
0005435038657	5474	35	9B
0005435006613	5474	36	9C
0005435038663	5474	37	9F
0005435038616	5474	38	9E
0005435038640	5474	39	10B
0005432125325	5474	40	10C
0005435038622	5474	41	10E
0005435038651	5474	42	11A
0005435038654	5474	43	11B
0005435038625	5474	44	11C
0005435038647	5474	45	11D
0005435038637	5474	46	11F
0005432125318	5474	47	12A
0005435038650	5474	48	12D
0005435038639	5474	49	12E
0005435038653	5474	50	13B
0005435038641	5474	51	13A
0005435038628	5474	52	13F
0005435038646	5474	53	14B
0005435006615	5474	54	14D
0005435038671	5474	55	14E
0005435038621	5474	56	14F
0005435006609	5474	57	15C
0005435038649	5474	58	15B
0005435038620	5474	59	15D
0005435038670	5474	60	15F
0005435038615	5474	61	16A
0005435006614	5474	62	16B
0005435042820	5474	63	16C
0005435038614	5474	64	16D
0005435006617	5474	65	16F
0005435006605	5474	66	17B
0005435038612	5474	67	17A
0005435042822	5474	68	17C
0005435038624	5474	69	17E
0005435038658	5474	70	17D
0005435038633	5474	71	17F
0005435038613	5474	72	18B
0005435006604	5474	73	18C
0005435038617	5474	74	18E
0005435038664	5474	75	18D
0005435006601	5474	76	19A
0005432125323	5474	77	19C
0005432125320	5474	78	19E
0005435038644	5474	79	19D
0005435038655	5474	80	19F
0005435042823	5474	81	20A
0005435038634	5474	82	20E
0005435006608	5474	83	20F
0005435042821	5474	84	21B
0005435006619	5474	85	21A
0005435006612	5474	86	21C
0005435038673	5474	87	21E
0005435038629	5474	88	22B
0005435038623	5474	89	22A
0005435038632	5474	90	22C
0005435006620	5474	91	22D
0005435038674	5474	92	22F
0005435038669	5474	93	23B
0005435038660	5474	94	23A
0005435038630	5474	95	23C
0005435038667	5474	96	23E
0005435038635	5474	97	23D
0005435038636	5474	98	23F
0005432304331	12973	1	1F
0005434228978	12973	2	2D
0005434228981	12973	3	5F
0005434228980	12973	4	7B
0005434228970	12973	5	8A
0005434228986	12973	6	8C
0005432304330	12973	7	8E
0005434228988	12973	8	11C
0005434228975	12973	9	11B
0005434228967	12973	10	12C
0005434228968	12973	11	13D
0005434228977	12973	12	14C
0005434228985	12973	13	15C
0005434228971	12973	14	16A
0005432304329	12973	15	17C
0005434228982	12973	16	18D
0005434228979	12973	17	18C
0005434228973	12973	18	19A
0005434228983	12973	19	19C
0005434228987	12973	20	19E
0005434228984	12973	21	20A
0005434228972	12973	22	20D
0005434228974	12973	23	21B
0005434228966	12973	24	22D
0005434228969	12973	25	23B
0005434228976	12973	26	23E
0005432059471	20234	1	1F
0005435554107	20234	2	2A
0005432059469	20234	3	2C
0005435902395	20234	4	2F
0005435902389	20234	5	4C
0005435902393	20234	6	5E
0005435902398	20234	7	6A
0005435902387	20234	8	6F
0005435554103	20234	9	7F
0005435902385	20234	10	9C
0005435902390	20234	11	11D
0005432059470	20234	12	11E
0005435902388	20234	13	11F
0005435554106	20234	14	13C
0005435902397	20234	15	13D
0005435902391	20234	16	13E
0005435902400	20234	17	14A
0005435554104	20234	18	15F
0005435902392	20234	19	16C
0005435902399	20234	20	16F
0005435902401	20234	21	17C
0005435902396	20234	22	18D
0005435902384	20234	23	18F
0005435902386	20234	24	19A
0005435554105	20234	25	19C
0005435902394	20234	26	20F
0005434269067	26680	1	1C
0005433434207	26680	2	2A
0005433434206	26680	3	2C
0005433434187	26680	4	3C
0005433434186	26680	5	4D
0005433434196	26680	6	5C
0005433434181	26680	7	5E
0005433434194	26680	8	6A
0005434269068	26680	9	6C
0005433434195	26680	10	7D
0005433434182	26680	11	7F
0005433434201	26680	12	8A
0005433434198	26680	13	8C
0005433434197	26680	14	8E
0005433434205	26680	15	9C
0005433434202	26680	16	10C
0005433434191	26680	17	10D
0005433434203	26680	18	10E
0005433434208	26680	19	10F
0005433434180	26680	20	11A
0005433434188	26680	21	11C
0005433434192	26680	22	11D
0005434270171	26680	23	12C
0005432051074	26680	24	12D
0005433434183	26680	25	12F
0005434269069	26680	26	13C
0005433434204	26680	27	13E
0005433434184	26680	28	14E
0005433434199	26680	29	15A
0005432051076	26680	30	15D
0005434271275	26680	31	16A
0005433434200	26680	32	16E
0005433434185	26680	33	17C
0005432051075	26680	34	18C
0005433434193	26680	35	19C
0005434270170	26680	36	19D
0005433434190	26680	37	19F
0005433434189	26680	38	20E
0005434271276	26680	39	20F
0005432583598	3180	1	1B
0005432583604	3180	2	1C
0005432583594	3180	3	1D
0005432583591	3180	4	2A
0005432583589	3180	5	2B
0005432583586	3180	6	3C
0005432583606	3180	7	3D
0005432583588	3180	8	4A
0005432583592	3180	9	4B
0005432583600	3180	10	4C
0005432583590	3180	11	4D
0005432583582	3180	12	5B
0005432583585	3180	13	5D
0005432583596	3180	14	6B
0005432583599	3180	15	6C
0005432583583	3180	16	7A
0005432583605	3180	17	7D
0005432583597	3180	18	18A
0005432583584	3180	19	18B
0005432583593	3180	20	19B
0005432583603	3180	21	19C
0005432216222	3180	22	20A
0005432583601	3180	23	20B
0005432216223	3180	24	21B
0005432583602	3180	25	21C
0005432583595	3180	26	22B
0005432583587	3180	27	22D
0005432216224	3180	28	23B
0005432857855	31520	1	2B
0005432857858	31520	2	2C
0005432857852	31520	3	3D
0005432857856	31520	4	4C
0005432857854	31520	5	5B
0005432857860	31520	6	5D
0005432857857	31520	7	6A
0005432857861	31520	8	18D
0005432857859	31520	9	20B
0005432857853	31520	10	21A
0005432857863	31520	11	21D
0005432857862	31520	12	22A
0005434943193	912	1	1D
0005434943187	912	2	3B
0005434943184	912	3	4A
0005434943186	912	4	4C
0005434943191	912	5	5B
0005434943194	912	6	6C
0005434943190	912	7	6D
0005434943185	912	8	7C
0005434943189	912	9	20A
0005434943192	912	10	21C
0005434943188	912	11	23B
0005433255025	16199	1	1A
0005433255023	16199	2	2B
0005433255021	16199	3	5A
0005433255024	16199	4	6B
0005433255022	16199	5	18A
0005433654647	4322	1	3D
0005433654653	4322	2	8E
0005433654648	4322	3	9E
0005433654652	4322	4	9F
0005433654651	4322	5	15C
0005433654650	4322	6	16F
0005433654654	4322	7	17F
0005433654649	4322	8	21D
0005433804791	9336	1	1C
0005433784317	9336	2	1G
0005433762954	9336	3	2H
0005433784328	9336	4	2G
0005432666352	9336	5	3B
0005433804783	9336	6	3G
0005433784321	9336	7	4C
0005433804779	9336	8	4B
0005433804784	9336	9	4F
0005433762944	9336	10	5B
0005433804788	9336	11	5C
0005433784297	9336	12	5G
0005433784312	9336	13	5H
0005433784306	9336	14	12A
0005432665238	9336	15	12E
0005433784316	9336	16	12F
0005433784327	9336	17	13A
0005433784305	9336	18	13B
0005432657393	9336	19	13D
0005433784294	9336	20	13G
0005433762942	9336	21	13F
0005433762949	9336	22	14A
0005433762953	9336	23	15D
0005433784299	9336	24	15F
0005433784326	9336	25	15H
0005433784302	9336	26	16A
0005433784292	9336	27	16H
0005433784313	9336	28	16G
0005433762955	9336	29	17A
0005433784322	9336	30	17D
0005433804780	9336	31	17B
0005433784324	9336	32	17H
0005432666353	9336	33	18F
0005433804785	9336	34	18H
0005433784320	9336	35	19B
0005433784318	9336	36	20H
0005433784295	9336	37	21B
0005432665237	9336	38	21E
0005433804790	9336	39	22D
0005433762943	9336	40	22G
0005433784301	9336	41	23B
0005433804792	9336	42	23A
0005433784319	9336	43	23H
0005433762948	9336	44	24E
0005432657395	9336	45	24H
0005433762950	9336	46	27A
0005433804787	9336	47	27D
0005433762951	9336	48	27H
0005433762956	9336	49	27G
0005433762946	9336	50	28B
0005433784296	9336	51	28F
0005433762947	9336	52	30H
0005433804781	9336	53	31F
0005433784311	9336	54	31H
0005433804778	9336	55	32D
0005433804782	9336	56	32B
0005433784315	9336	57	32G
0005433804777	9336	58	33H
0005433784293	9336	59	34A
0005433784304	9336	60	34D
0005432657394	9336	61	34B
0005433804789	9336	62	34G
0005433784325	9336	63	35G
0005433784309	9336	64	36B
0005433784300	9336	65	36A
0005433804793	9336	66	36E
0005433784298	9336	67	36D
0005433784307	9336	68	36F
0005432666351	9336	69	36H
0005433784310	9336	70	37E
0005433784314	9336	71	38A
0005433804786	9336	72	38B
0005433784303	9336	73	38H
0005433762952	9336	74	38G
0005433784323	9336	75	39E
0005433762945	9336	76	39D
0005433784308	9336	77	39F
0005434170798	26277	1	2G
0005435269632	26277	2	4C
0005435269631	26277	3	9G
0005434170806	26277	4	11B
0005434170804	26277	5	12E
0005435269628	26277	6	12H
0005435269633	26277	7	14B
0005435269625	26277	8	15E
0005434170807	26277	9	15F
0005435269634	26277	10	15H
0005435269622	26277	11	16A
0005434170801	26277	12	16G
0005435269641	26277	13	17B
0005434170797	26277	14	18E
0005434170810	26277	15	19G
0005435269621	26277	16	19H
0005435269624	26277	17	22D
0005435269635	26277	18	23D
0005435269639	26277	19	24A
0005434170809	26277	20	25F
0005434170805	26277	21	27D
0005435269642	26277	22	30E
0005434170800	26277	23	31F
0005435269623	26277	24	31G
0005435269640	26277	25	32B
0005435269627	26277	26	32D
0005435269636	26277	27	32H
0005434170803	26277	28	33B
0005434170802	26277	29	34A
0005435269626	26277	30	34E
0005434170808	26277	31	36A
0005434170799	26277	32	35H
0005435269638	26277	33	37F
0005435269630	26277	34	39E
0005435269629	26277	35	39D
0005435269637	26277	36	39F
0005435135585	4920	1	2D
0005435135582	4920	2	7C
0005435135583	4920	3	21B
0005435135584	4920	4	23A
0005435929595	33055	1	2A
0005435929597	33055	2	7B
0005435929596	33055	3	18D
0005434983194	9467	1	2D
0005434983198	9467	2	4A
0005434983195	9467	3	6B
0005434983197	9467	4	7A
0005434983196	9467	5	21B
0005434983193	9467	6	22C
0005434217896	27368	1	5A
0005434217894	27368	2	6B
0005434217897	27368	3	18B
0005434217895	27368	4	22B
0005434217898	27368	5	22D
0005434479880	923	1	1B
0005434479885	923	2	1C
0005434479896	923	3	2A
0005432269447	923	4	2B
0005434479888	923	5	2C
0005434479903	923	6	2D
0005432269445	923	7	4A
0005434479893	923	8	4B
0005434479894	923	9	4C
0005434479895	923	10	5B
0005434479879	923	11	5C
0005434479900	923	12	5D
0005434479897	923	13	6A
0005434479886	923	14	6C
0005434479890	923	15	7C
0005434479901	923	16	18A
0005434479878	923	17	18B
0005432269446	923	18	18C
0005434479881	923	19	19A
0005434479898	923	20	19C
0005434479902	923	21	20A
0005434479892	923	22	20B
0005434479883	923	23	20C
0005434479887	923	24	20D
0005434479882	923	25	21A
0005434479884	923	26	21C
0005434479889	923	27	21D
0005434479899	923	28	22A
0005434479891	923	29	23A
0005433165675	16590	1	1C
0005433165683	16590	2	2B
0005433165682	16590	3	2C
0005433165676	16590	4	4C
0005433165680	16590	5	4D
0005433165670	16590	6	6A
0005433165674	16590	7	6B
0005433165677	16590	8	6C
0005433165678	16590	9	6D
0005433165673	16590	10	18B
0005433165681	16590	11	19A
0005433165672	16590	12	20A
0005433165671	16590	13	20D
0005433165679	16590	14	22D
0005433872427	3194	1	2A
0005433872426	3194	2	19D
0005433872428	3194	3	23A
0005435386455	21926	1	1B
0005435386456	21926	2	1D
0005433289725	21926	3	5B
0005435386454	21926	4	6B
0005433289727	21926	5	21A
0005433289726	21926	6	21B
0005433289728	21926	7	22A
0005435386457	21926	8	22B
0005433289730	21926	9	22C
0005433289729	21926	10	22D
0005435319423	20931	1	2C
0005435319424	20931	2	3D
0005435319429	20931	3	5E
0005435319431	20931	4	6C
0005435319426	20931	5	10F
0005435319427	20931	6	11C
0005435319425	20931	7	12C
0005435319428	20931	8	14E
0005435319430	20931	9	17C
0005433683291	24306	1	3D
0005433683290	24306	2	4C
0005433683293	24306	3	19B
0005433683292	24306	4	19C
0005433927397	29277	1	3A
0005433927396	29277	2	3D
0005433927395	29277	3	5A
0005432706316	2926	1	1A
0005432706311	2926	2	1D
0005432706307	2926	3	2A
0005432217726	2926	4	2D
0005432706324	2926	5	4C
0005432706313	2926	6	4D
0005432706329	2926	7	6A
0005432706318	2926	8	6C
0005432706312	2926	9	6D
0005432706326	2926	10	7A
0005432706331	2926	11	7C
0005432706330	2926	12	8C
0005432706309	2926	13	8D
0005432706321	2926	14	9C
0005432706310	2926	15	9D
0005432706308	2926	16	9E
0005432706323	2926	17	10E
0005432706322	2926	18	10F
0005432706328	2926	19	11C
0005432217725	2926	20	12A
0005432706332	2926	21	12E
0005432706319	2926	22	13A
0005432706325	2926	23	13F
0005432706315	2926	24	14C
0005432706320	2926	25	17A
0005432706317	2926	26	17C
0005432706327	2926	27	18A
0005432706314	2926	28	18E
0005432217724	2926	29	18F
0005432692531	30019	1	1C
0005432692533	30019	2	1F
0005432692527	30019	3	3C
0005432692534	30019	4	3F
0005432880563	30019	5	4A
0005432880561	30019	6	4D
0005432692552	30019	7	5A
0005432692547	30019	8	5E
0005432880555	30019	9	5F
0005432692541	30019	10	6A
0005432692556	30019	11	6D
0005432692553	30019	12	6E
0005432692545	30019	13	6F
0005432692529	30019	14	7C
0005432692528	30019	15	7E
0005432692549	30019	16	7D
0005432880557	30019	17	8C
0005432880562	30019	18	8F
0005432692554	30019	19	9C
0005432692550	30019	20	9E
0005432692557	30019	21	10D
0005432692543	30019	22	11A
0005432692539	30019	23	11C
0005432880551	30019	24	11F
0005432692536	30019	25	12C
0005432692540	30019	26	13A
0005432880553	30019	27	13C
0005432880554	30019	28	14C
0005432692555	30019	29	14D
0005432692546	30019	30	14E
0005432880558	30019	31	15A
0005432692548	30019	32	15D
0005432692551	30019	33	15E
0005432880552	30019	34	16A
0005432880565	30019	35	16D
0005432880564	30019	36	17A
0005432692530	30019	37	17D
0005432880560	30019	38	17F
0005432692538	30019	39	18A
0005432692532	30019	40	18D
0005432692558	30019	41	18E
0005432692544	30019	42	18F
0005432692535	30019	43	19C
0005432880556	30019	44	19D
0005432692542	30019	45	19F
0005432692537	30019	46	20D
0005432880559	30019	47	20F
0005433113495	19632	1	2A
0005433113496	19632	2	19A
0005435068172	3533	1	1A
0005435068190	3533	2	1C
0005435068181	3533	3	1D
0005435068175	3533	4	2D
0005435718830	3533	5	2F
0005435068200	3533	6	3A
0005435068194	3533	7	3C
0005435068180	3533	8	4C
0005435068210	3533	9	4E
0005435068207	3533	10	4D
0005435068163	3533	11	5C
0005435718828	3533	12	5D
0005435718827	3533	13	5F
0005435068160	3533	14	6A
0005435068161	3533	15	6C
0005435068176	3533	16	6D
0005435068170	3533	17	7A
0005435068168	3533	18	7D
0005435068199	3533	19	7E
0005435068162	3533	20	7F
0005435068169	3533	21	8D
0005435718831	3533	22	8E
0005435068184	3533	23	8F
0005435068195	3533	24	9D
0005435068208	3533	25	9E
0005435068178	3533	26	9F
0005435068192	3533	27	10A
0005435068174	3533	28	10C
0005435068183	3533	29	10D
0005435068198	3533	30	11A
0005435068166	3533	31	11C
0005435068191	3533	32	11E
0005435068187	3533	33	12D
0005435718829	3533	34	12E
0005435068173	3533	35	12F
0005435068158	3533	36	13C
0005435068171	3533	37	13E
0005435068202	3533	38	13F
0005435068209	3533	39	14D
0005435068164	3533	40	14E
0005435068159	3533	41	15E
0005435068197	3533	42	15F
0005435068204	3533	43	16A
0005435068179	3533	44	16D
0005435068205	3533	45	16F
0005435068185	3533	46	17A
0005435068193	3533	47	17E
0005435068201	3533	48	17F
0005435068188	3533	49	18A
0005435068206	3533	50	18C
0005435068186	3533	51	18D
0005435068189	3533	52	18F
0005435068196	3533	53	19A
0005435068203	3533	54	19C
0005435068177	3533	55	19D
0005435068182	3533	56	19F
0005435068167	3533	57	20A
0005435068165	3533	58	20E
0005435925060	15302	1	4A
0005435925056	15302	2	4E
0005435925051	15302	3	5C
0005435925049	15302	4	6D
0005435925048	15302	5	8E
0005435925057	15302	6	9A
0005435925052	15302	7	9C
0005435925046	15302	8	9D
0005435939856	15302	9	11D
0005435925053	15302	10	15E
0005435925058	15302	11	16C
0005435925047	15302	12	17A
0005435925059	15302	13	17E
0005435925055	15302	14	19C
0005435925050	15302	15	20A
0005435925054	15302	16	20D
0005432157458	62	1	5F
0005432157457	62	2	25C
0005432816945	1	1	2C
0005432261133	1	2	2F
0005432261100	1	3	2D
0005432261098	1	4	4A
0005432261099	1	5	4F
0005432816962	1	6	5C
0005432261101	1	7	5F
0005432816959	1	8	6D
0005432261122	1	9	6C
0005432261110	1	10	6F
0005432261129	1	11	7C
0005432261096	1	12	7F
0005432816955	1	13	8A
0005432261119	1	14	8D
0005432816943	1	15	8C
0005432816947	1	16	9A
0005432816938	1	17	8F
0005432261090	1	18	9C
0005432816951	1	19	9D
0005432816960	1	20	9F
0005432261115	1	21	10B
0005432816954	1	22	10D
0005432816961	1	23	10E
0005432261097	1	24	10F
0005432261092	1	25	11B
0005432816963	1	26	11C
0005432261103	1	27	11D
0005432261116	1	28	11E
0005432816939	1	29	12A
0005432261109	1	30	11F
0005432261126	1	31	12E
0005432261121	1	32	12D
0005432816940	1	33	12F
0005432261120	1	34	13D
0005432261087	1	35	14B
0005432816965	1	36	14D
0005432288927	1	37	14E
0005432261112	1	38	14F
0005432261127	1	39	15B
0005432816958	1	40	15D
0005432816946	1	41	16E
0005432261114	1	42	16D
0005432816964	1	43	16F
0005432261132	1	44	17A
0005432261113	1	45	17F
0005432816952	1	46	18A
0005432261125	1	47	18B
0005432261118	1	48	18D
0005432261102	1	49	18C
0005432261128	1	50	19E
0005432816966	1	51	19D
0005432288929	1	52	20A
0005432261091	1	53	20C
0005432261123	1	54	20E
0005432261107	1	55	20F
0005432261094	1	56	21F
0005432816957	1	57	22A
0005432261111	1	58	22B
0005432261124	1	59	22D
0005432261108	1	60	23B
0005432816948	1	61	24A
0005432261093	1	62	25B
0005432816949	1	63	25D
0005432816953	1	64	25C
0005432816950	1	65	26A
0005432261130	1	66	26E
0005432261095	1	67	27A
0005432261089	1	68	27B
0005432261117	1	69	27E
0005432816942	1	70	27D
0005432816956	1	71	28E
0005432261131	1	72	28F
0005432261105	1	73	29D
0005432261106	1	74	29F
0005432288928	1	75	30B
0005432261104	1	76	30D
0005432816944	1	77	30E
0005432261088	1	78	31A
0005432816941	1	79	31E
0005433101217	8078	1	1D
0005433101189	8078	2	2A
0005432391945	8078	3	1F
0005433101183	8078	4	2C
0005433101197	8078	5	2F
0005432019787	8078	6	3C
0005432019786	8078	7	3D
0005433101173	8078	8	4A
0005433101216	8078	9	3F
0005433101157	8078	10	4C
0005433101155	8078	11	4D
0005432391946	8078	12	5A
0005433101200	8078	13	5C
0005433101194	8078	14	5F
0005433101168	8078	15	6D
0005433101148	8078	16	7A
0005433101161	8078	17	6F
0005432753243	8078	18	7F
0005433101176	8078	19	7D
0005433101172	8078	20	8A
0005433101196	8078	21	8C
0005432751469	8078	22	9A
0005433101160	8078	23	9B
0005433101150	8078	24	9C
0005432019796	8078	25	9D
0005433101190	8078	26	9E
0005432045579	8078	27	10A
0005433101210	8078	28	10C
0005433101171	8078	29	10B
0005432019794	8078	30	10D
0005433101204	8078	31	10E
0005432019779	8078	32	10F
0005433101154	8078	33	11A
0005433101184	8078	34	11B
0005432753242	8078	35	11D
0005433101220	8078	36	11E
0005432019780	8078	37	12A
0005433101162	8078	38	12B
0005433101178	8078	39	12C
0005433101170	8078	40	12D
0005432019797	8078	41	12E
0005433101207	8078	42	13B
0005433101212	8078	43	13C
0005432019784	8078	44	13D
0005433101164	8078	45	13F
0005433101202	8078	46	13E
0005432019793	8078	47	14A
0005432677503	8078	48	14B
0005433101169	8078	49	14C
0005433101187	8078	50	14E
0005433101182	8078	51	14F
0005432019792	8078	52	15A
0005432044475	8078	53	15C
0005432044477	8078	54	15B
0005433101219	8078	55	15F
0005432019801	8078	56	15E
0005433101209	8078	57	16B
0005432045580	8078	58	16D
0005433101213	8078	59	16F
0005432019800	8078	60	17F
0005433101205	8078	61	17E
0005433101208	8078	62	18A
0005433101179	8078	63	18C
0005433101159	8078	64	18B
0005433101203	8078	65	18D
0005433101195	8078	66	19B
0005432019789	8078	67	18F
0005433101193	8078	68	20A
0005432019790	8078	69	19E
0005433101152	8078	70	20C
0005433101206	8078	71	20D
0005433101192	8078	72	20F
0005432019783	8078	73	21A
0005433101199	8078	74	21C
0005433101177	8078	75	21B
0005433101167	8078	76	22B
0005433101163	8078	77	22A
0005432019804	8078	78	22E
0005433101211	8078	79	22D
0005432019781	8078	80	22F
0005433101201	8078	81	23A
0005433101165	8078	82	23D
0005432751468	8078	83	23C
0005432045581	8078	84	23E
0005433101149	8078	85	24A
0005433101185	8078	86	24D
0005433101214	8078	87	24C
0005433101198	8078	88	24F
0005432019799	8078	89	25A
0005433101151	8078	90	25C
0005433101175	8078	91	25B
0005433101188	8078	92	25D
0005432019802	8078	93	25E
0005433101166	8078	94	26A
0005432019785	8078	95	25F
0005432677506	8078	96	26B
0005432391947	8078	97	26C
0005432019795	8078	98	26E
0005432019803	8078	99	26F
0005433101186	8078	100	27B
0005432677504	8078	101	27E
0005433101218	8078	102	27D
0005432019782	8078	103	28B
0005433101180	8078	104	28D
0005432019788	8078	105	28F
0005433101158	8078	106	29A
0005432019791	8078	107	29C
0005432677505	8078	108	29E
0005432044476	8078	109	30A
0005432753244	8078	110	30B
0005433101156	8078	111	30D
0005433101153	8078	112	31A
0005433101181	8078	113	30F
0005432019798	8078	114	31B
0005433101215	8078	115	31C
0005433101191	8078	116	31F
0005433101174	8078	117	31E
0005432901293	8076	1	1C
0005432901302	8076	2	1F
0005432901304	8076	3	5C
0005432901295	8076	4	6D
0005432901310	8076	5	8D
0005432901298	8076	6	8C
0005432901307	8076	7	8F
0005432901309	8076	8	9C
0005432901308	8076	9	10B
0005432901297	8076	10	10D
0005432901300	8076	11	15B
0005432002040	8076	12	15F
0005432002041	8076	13	17D
0005432901299	8076	14	18C
0005432901303	8076	15	19E
0005432901296	8076	16	20C
0005432901306	8076	17	23A
0005432901294	8076	18	25B
0005432901311	8076	19	28D
0005432901301	8076	20	30B
0005432901305	8076	21	30D
0005433870692	9671	1	3B
0005433870691	9671	2	5B
0005434175681	32374	1	1A
0005434175678	32374	2	2B
0005434175680	32374	3	4A
0005434175679	32374	4	5A
0005434175682	32374	5	6B
0005434876559	3490	1	1A
0005435625879	3490	2	1G
0005432798964	3490	3	1D
0005434876557	3490	4	1K
0005435625862	3490	5	1H
0005432798955	3490	6	2D
0005434876620	3490	7	2C
0005435125675	3490	8	2A
0005434876651	3490	9	2H
0005434876564	3490	10	2G
0005434876581	3490	11	3A
0005432613790	3490	12	2K
0005435125669	3490	13	3D
0005435125656	3490	14	3C
0005434876585	3490	15	3H
0005432798962	3490	16	4A
0005432798966	3490	17	4G
0005434426109	3490	18	4K
0005435625868	3490	19	4H
0005434426101	3490	20	5C
0005435625876	3490	21	5A
0005434876593	3490	22	5H
0005434876614	3490	23	11A
0005434876575	3490	24	5K
0005434876617	3490	25	11E
0005434876565	3490	26	11D
0005435625858	3490	27	11C
0005435125677	3490	28	11F
0005432798969	3490	29	11G
0005434876583	3490	30	12A
0005435125661	3490	31	12E
0005432798961	3490	32	12G
0005435625877	3490	33	12F
0005434876621	3490	34	12K
0005434876636	3490	35	13F
0005434937796	3490	36	13E
0005434876558	3490	37	13H
0005435625873	3490	38	13G
0005435125665	3490	39	14A
0005434876650	3490	40	14G
0005435125651	3490	41	14F
0005434876580	3490	42	14K
0005434876578	3490	43	15C
0005435125663	3490	44	15E
0005432613789	3490	45	15G
0005434426085	3490	46	15H
0005434426092	3490	47	16C
0005434876633	3490	48	16A
0005435125688	3490	49	16E
0005434426091	3490	50	16H
0005434937810	3490	51	16G
0005434876569	3490	52	17A
0005434876600	3490	53	17E
0005432798977	3490	54	17D
0005435125678	3490	55	17C
0005434876582	3490	56	17F
0005434876608	3490	57	17K
0005434876609	3490	58	18C
0005432798956	3490	59	18E
0005434876574	3490	60	18D
0005434426093	3490	61	18F
0005434876591	3490	62	18K
0005435625867	3490	63	18J
0005434937805	3490	64	18H
0005435125682	3490	65	19B
0005435625857	3490	66	19A
0005434876640	3490	67	19D
0005435125687	3490	68	19C
0005435625869	3490	69	19E
0005435625863	3490	70	19J
0005434937808	3490	71	19H
0005435125666	3490	72	20A
0005434876584	3490	73	19K
0005435125652	3490	74	20B
0005435125653	3490	75	20E
0005434876599	3490	76	20C
0005435125657	3490	77	20K
0005434937802	3490	78	20J
0005435125655	3490	79	20H
0005435125674	3490	80	21A
0005432798972	3490	81	21D
0005434876598	3490	82	21F
0005434426096	3490	83	22A
0005434876646	3490	84	21K
0005435625875	3490	85	22C
0005434426102	3490	86	22B
0005434426099	3490	87	22E
0005435625861	3490	88	22D
0005434876639	3490	89	22G
0005434426098	3490	90	22F
0005434426105	3490	91	22K
0005434937792	3490	92	22H
0005434876619	3490	93	23B
0005434426088	3490	94	23A
0005434937809	3490	95	23D
0005434426089	3490	96	23C
0005432798968	3490	97	23G
0005434937797	3490	98	23F
0005434876642	3490	99	23E
0005432188550	3490	100	23J
0005435125671	3490	101	23H
0005434426104	3490	102	23K
0005434937793	3490	103	25A
0005434876615	3490	104	24G
0005432188551	3490	105	25C
0005434876616	3490	106	25B
0005434426095	3490	107	25F
0005434937806	3490	108	25E
0005434876618	3490	109	25G
0005432188553	3490	110	26A
0005435625865	3490	111	25J
0005434426113	3490	112	26D
0005434876610	3490	113	26C
0005432798979	3490	114	26H
0005434876597	3490	115	26F
0005434876626	3490	116	27B
0005434876606	3490	117	27A
0005434937804	3490	118	26K
0005434876622	3490	119	27D
0005432798976	3490	120	27C
0005434426110	3490	121	27F
0005435125659	3490	122	27H
0005434876568	3490	123	27K
0005434876647	3490	124	27J
0005434876560	3490	125	28C
0005435625874	3490	126	28B
0005432798954	3490	127	28D
0005435625878	3490	128	28G
0005432183428	3490	129	28H
0005434876624	3490	130	29B
0005432798965	3490	131	29A
0005434876571	3490	132	29D
0005432798975	3490	133	29C
0005435125660	3490	134	29F
0005434876627	3490	135	29E
0005432798971	3490	136	29H
0005435125672	3490	137	29K
0005434426112	3490	138	30C
0005434937799	3490	139	30B
0005434876570	3490	140	30D
0005434876630	3490	141	30G
0005434937800	3490	142	30E
0005434876629	3490	143	30K
0005434426108	3490	144	31D
0005434876645	3490	145	31C
0005435125647	3490	146	31F
0005434426094	3490	147	31J
0005432798970	3490	148	31G
0005434876587	3490	149	31K
0005435625871	3490	150	32C
0005434937795	3490	151	32B
0005432613792	3490	152	32A
0005435125686	3490	153	32E
0005434876590	3490	154	32G
0005434426107	3490	155	32J
0005432188552	3490	156	32H
0005432613791	3490	157	33B
0005434426097	3490	158	33A
0005434876556	3490	159	33F
0005435125670	3490	160	33E
0005434876572	3490	161	33G
0005434876635	3490	162	33K
0005434876576	3490	163	34B
0005435125676	3490	164	34A
0005434876623	3490	165	34E
0005435125667	3490	166	34H
0005434937807	3490	167	34G
0005434876612	3490	168	34J
0005432798981	3490	169	35B
0005434876596	3490	170	35A
0005434876605	3490	171	34K
0005434876631	3490	172	35C
0005434876602	3490	173	35F
0005434876603	3490	174	35E
0005435625864	3490	175	35H
0005434426100	3490	176	35G
0005434876563	3490	177	35J
0005434876632	3490	178	36C
0005434876634	3490	179	36E
0005434937798	3490	180	36D
0005434876577	3490	181	36F
0005434876604	3490	182	36K
0005435125685	3490	183	36J
0005434876628	3490	184	37B
0005435125648	3490	185	37A
0005435625872	3490	186	37E
0005432798960	3490	187	37D
0005434426090	3490	188	37F
0005434876566	3490	189	37J
0005434876637	3490	190	38B
0005435625860	3490	191	39A
0005434937803	3490	192	39D
0005434876595	3490	193	39B
0005435125650	3490	194	39G
0005434876625	3490	195	39J
0005432798980	3490	196	40C
0005432798958	3490	197	40E
0005434937794	3490	198	40D
0005432183429	3490	199	40H
0005434426084	3490	200	40F
0005435625859	3490	201	40J
0005435125668	3490	202	41B
0005434876638	3490	203	40K
0005434876588	3490	204	41D
0005435125683	3490	205	41C
0005434426086	3490	206	41F
0005434426106	3490	207	41G
0005434426087	3490	208	42A
0005432188549	3490	209	41J
0005435125664	3490	210	42E
0005435125658	3490	211	42F
0005432798974	3490	212	42J
0005434876648	3490	213	43A
0005434426111	3490	214	42K
0005434876644	3490	215	43C
0005434876567	3490	216	43B
0005434876611	3490	217	43E
0005434426103	3490	218	43H
0005432798957	3490	219	43J
0005432798978	3490	220	44C
0005435625870	3490	221	44A
0005434876613	3490	222	44D
0005435125681	3490	223	44G
0005434937801	3490	224	44F
0005434876594	3490	225	44J
0005435125673	3490	226	45B
0005432798967	3490	227	45A
0005432798963	3490	228	45H
0005434876561	3490	229	46B
0005432798953	3490	230	46A
0005434876562	3490	231	46F
0005434876641	3490	232	46H
0005434876643	3490	233	47E
0005432798973	3490	234	47D
0005432798982	3490	235	47C
0005434876601	3490	236	48A
0005434876586	3490	237	47K
0005434876592	3490	238	47H
0005434876589	3490	239	48C
0005435125684	3490	240	48F
0005435125649	3490	241	48H
0005434876573	3490	242	49A
0005435125654	3490	243	49E
0005435125680	3490	244	49G
0005434876555	3490	245	49F
0005435625866	3490	246	49K
0005434876579	3490	247	49H
0005435125679	3490	248	50C
0005434937811	3490	249	50A
0005435125662	3490	250	50E
0005434876649	3490	251	50H
0005432798959	3490	252	50F
0005434876607	3490	253	50K
0005435902395	14551	1	2A
0005435902390	14551	2	2H
0005435902388	14551	3	4G
0005432059471	14551	4	5A
0005435902400	14551	5	5H
0005435913849	14551	6	11D
0005432059469	14551	7	12C
0005435902384	14551	8	13F
0005435902389	14551	9	25B
0005435902386	14551	10	26D
0005435902385	14551	11	27F
0005435902401	14551	12	28G
0005435902398	14551	13	30A
0005435902396	14551	14	30K
0005435902387	14551	15	33D
0005435902397	14551	16	33G
0005432059470	14551	17	35K
0005435902399	14551	18	36D
0005435902394	14551	19	39B
0005435902393	14551	20	45J
0005435902391	14551	21	46J
0005435913850	14551	22	48F
0005435902392	14551	23	48D
0005434325452	3625	1	1A
0005434325451	3625	2	1C
0005434325445	3625	3	1D
0005434325450	3625	4	2C
0005434325446	3625	5	3A
0005434325453	3625	6	3D
0005434325448	3625	7	5A
0005434325447	3625	8	6C
0005434325444	3625	9	7C
0005434325443	3625	10	19B
0005434325449	3625	11	19C
0005434325454	3625	12	20C
0005434325455	3625	13	21B
0005435889790	15639	1	4C
0005435889793	15639	2	5C
0005435889791	15639	3	7C
0005435889789	15639	4	7D
0005435889788	15639	5	21A
0005435889792	15639	6	22A
0005435957441	669	1	1B
0005435957438	669	2	4B
0005435957450	669	3	4C
0005435957447	669	4	5B
0005435957453	669	5	5D
0005435957445	669	6	6A
0005435957449	669	7	7A
0005435957448	669	8	7C
0005435957440	669	9	18A
0005435957439	669	10	18D
0005435957444	669	11	19A
0005435957451	669	12	19B
0005435957443	669	13	19D
0005435957452	669	14	21C
0005435957442	669	15	22D
0005435957446	669	16	23B
0005433420253	15177	1	1B
0005433420249	15177	2	2B
0005433420252	15177	3	3A
0005433420256	15177	4	3B
0005433420251	15177	5	4C
0005433420254	15177	6	20B
0005433420255	15177	7	20D
0005433420257	15177	8	21D
0005433420250	15177	9	22A
0005435217676	31773	1	1A
0005435218099	31773	2	5B
0005435216554	31773	3	6A
0005435217677	31773	4	21C
0005435217678	31773	5	22A
0005435216553	31773	6	22D
0005435629383	8849	1	1B
0005434247102	16118	1	1A
0005434247100	16118	2	2B
0005434247101	16118	3	3B
0005434467723	4016	1	4B
0005434467724	4016	2	5A
0005435163143	4432	1	3A
0005435163141	4432	2	5A
0005435163142	4432	3	5C
0005435163144	4432	4	5D
0005435163140	4432	5	18D
0005435163139	4432	6	22A
0005435933395	29506	1	1C
0005435933394	29506	2	6D
0005432645761	6840	1	1A
0005432645768	6840	2	2D
0005432645773	6840	3	3D
0005432645767	6840	4	4E
0005432645764	6840	5	7C
0005432645765	6840	6	10D
0005432645763	6840	7	12F
0005432645766	6840	8	14F
0005432645762	6840	9	15D
0005432645772	6840	10	15E
0005432645769	6840	11	15F
0005432645771	6840	12	17A
0005432645770	6840	13	19F
0005435797234	2837	1	2C
0005435797224	2837	2	4A
0005435797223	2837	3	4D
0005435797226	2837	4	6A
0005435797227	2837	5	8E
0005435797222	2837	6	9D
0005435797230	2837	7	10C
0005435797233	2837	8	11C
0005435797225	2837	9	12A
0005435797231	2837	10	13F
0005435797236	2837	11	14C
0005435797232	2837	12	16C
0005435797235	2837	13	19D
0005435797229	2837	14	20A
0005435797228	2837	15	20F
0005433404679	29309	1	1C
0005433404677	29309	2	3A
0005433404683	29309	3	5C
0005433404681	29309	4	14D
0005433404678	29309	5	15A
0005433404680	29309	6	17C
0005433404682	29309	7	19E
0005434947871	5814	1	1A
0005434947870	5814	2	3A
0005434947868	5814	3	3B
0005434947869	5814	4	4A
0005434947874	5814	5	4B
0005434947872	5814	6	5B
0005434947873	5814	7	6A
0005435376312	16432	1	4A
0005435376313	16432	2	6A
0005435376314	16432	3	6B
0005433959869	6863	1	1A
0005433959896	6863	2	1D
0005433959866	6863	3	2C
0005433959860	6863	4	2D
0005433959895	6863	5	3A
0005433959903	6863	6	3D
0005433959865	6863	7	3F
0005433959883	6863	8	4C
0005433959864	6863	9	4D
0005433959879	6863	10	4E
0005433959891	6863	11	5A
0005433959882	6863	12	5C
0005433959871	6863	13	5F
0005433959872	6863	14	6F
0005433959888	6863	15	7A
0005433959889	6863	16	8A
0005433959900	6863	17	8C
0005433959857	6863	18	8E
0005433959881	6863	19	9D
0005433959893	6863	20	10C
0005433959867	6863	21	10E
0005433959898	6863	22	11A
0005433959870	6863	23	11C
0005433959885	6863	24	11E
0005433959863	6863	25	11F
0005433959887	6863	26	12A
0005433959858	6863	27	12F
0005433959877	6863	28	13E
0005433959902	6863	29	13D
0005433959894	6863	30	14A
0005433959897	6863	31	14C
0005433959876	6863	32	14F
0005433959874	6863	33	15A
0005433959892	6863	34	15E
0005433959862	6863	35	16C
0005433959899	6863	36	16E
0005433959868	6863	37	17C
0005433959859	6863	38	17D
0005433959873	6863	39	17E
0005433959861	6863	40	17F
0005433959875	6863	41	18E
0005433959856	6863	42	18F
0005433959878	6863	43	19E
0005433959901	6863	44	20A
0005433959884	6863	45	20C
0005433959880	6863	46	20D
0005433959886	6863	47	20E
0005433959890	6863	48	20F
0005434244467	5200	1	2D
0005434244473	5200	2	5A
0005434244459	5200	3	4F
0005434244463	5200	4	6A
0005434244453	5200	5	8A
0005434244466	5200	6	9C
0005434244469	5200	7	10A
0005434244470	5200	8	9F
0005434244479	5200	9	12A
0005434244457	5200	10	12E
0005434244462	5200	11	14A
0005434244456	5200	12	15D
0005434244480	5200	13	15E
0005434244477	5200	14	15F
0005434244458	5200	15	17D
0005434244455	5200	16	20A
0005434244478	5200	17	20C
0005434244481	5200	18	20F
0005432166843	5200	19	21C
0005434244476	5200	20	21B
0005432166845	5200	21	22C
0005434244468	5200	22	22E
0005434244464	5200	23	24B
0005434244474	5200	24	25C
0005434244475	5200	25	26A
0005434244471	5200	26	25F
0005434244461	5200	27	26D
0005434244454	5200	28	28A
0005434244482	5200	29	28D
0005434244483	5200	30	29B
0005434244472	5200	31	29E
0005432166844	5200	32	30A
0005434244465	5200	33	30F
0005434244460	5200	34	31B
0005432104729	5204	1	1A
0005433613444	5204	2	1C
0005432104738	5204	3	1F
0005433784315	5204	4	1D
0005433784293	5204	5	2A
0005433613453	5204	6	2C
0005432104714	5204	7	2F
0005433784299	5204	8	2D
0005432104734	5204	9	3A
0005433784312	5204	10	3C
0005432104711	5204	11	3D
0005433613386	5204	12	4A
0005432104749	5204	13	3F
0005433784324	5204	14	4C
0005432104740	5204	15	4F
0005433613433	5204	16	4D
0005433613388	5204	17	5C
0005433784313	5204	18	5A
0005433613452	5204	19	5D
0005433613418	5204	20	6A
0005433784304	5204	21	5F
0005432104735	5204	22	6C
0005433613429	5204	23	6F
0005432104736	5204	24	6D
0005432104742	5204	25	7A
0005432666351	5204	26	7C
0005433613421	5204	27	7D
0005432104728	5204	28	8A
0005433784308	5204	29	7F
0005433784309	5204	30	8B
0005432104759	5204	31	8D
0005432104755	5204	32	8C
0005432104732	5204	33	8E
0005433784311	5204	34	8F
0005433784328	5204	35	9B
0005433613460	5204	36	9A
0005433784301	5204	37	9C
0005432104751	5204	38	9E
0005433613407	5204	39	9D
0005433784292	5204	40	9F
0005432145075	5204	41	10A
0005432104747	5204	42	10C
0005433784317	5204	43	10B
0005433613393	5204	44	10D
0005433784297	5204	45	10E
0005433613435	5204	46	10F
0005433613409	5204	47	11A
0005433613455	5204	48	11C
0005432104725	5204	49	11B
0005432104723	5204	50	11D
0005432104717	5204	51	11E
0005432104744	5204	52	12A
0005433613431	5204	53	11F
0005433784314	5204	54	12C
0005433613408	5204	55	12B
0005433613395	5204	56	12D
0005433613448	5204	57	12E
0005432665237	5204	58	12F
0005432104758	5204	59	13A
0005432104713	5204	60	13C
0005433784305	5204	61	13B
0005433613458	5204	62	13D
0005432104712	5204	63	13F
0005433613419	5204	64	13E
0005433613441	5204	65	14A
0005433613415	5204	66	14C
0005433613423	5204	67	14B
0005433784295	5204	68	14D
0005433613437	5204	69	14F
0005432666352	5204	70	15B
0005432104752	5204	71	15A
0005433613445	5204	72	15C
0005433613397	5204	73	15D
0005433784323	5204	74	15F
0005433613414	5204	75	15E
0005432104715	5204	76	16A
0005432104731	5204	77	16B
0005433613404	5204	78	16D
0005433613424	5204	79	16C
0005432104718	5204	80	16E
0005433613411	5204	81	17A
0005433784316	5204	82	16F
0005433613412	5204	83	17C
0005433613401	5204	84	17B
0005433613420	5204	85	17E
0005433784296	5204	86	17D
0005433613425	5204	87	18A
0005432104748	5204	88	17F
0005433613400	5204	89	18B
0005433613457	5204	90	18C
0005433784318	5204	91	18E
0005432666353	5204	92	18D
0005433784300	5204	93	18F
0005433613396	5204	94	19C
0005432104753	5204	95	19B
0005432104757	5204	96	19D
0005433613416	5204	97	19E
0005433613417	5204	98	20B
0005433613440	5204	99	20A
0005433784322	5204	100	20C
0005433613426	5204	101	20D
0005433613443	5204	102	20F
0005432104727	5204	103	20E
0005433613459	5204	104	21A
0005433613394	5204	105	21C
0005432104722	5204	106	21B
0005433613451	5204	107	21D
0005433613405	5204	108	21E
0005432145077	5204	109	22A
0005432104741	5204	110	21F
0005433613392	5204	111	22B
0005433613454	5204	112	22D
0005433613427	5204	113	22C
0005432104750	5204	114	22E
0005432104726	5204	115	22F
0005433613436	5204	116	23B
0005432665238	5204	117	23A
0005433613430	5204	118	23C
0005433784325	5204	119	23D
0005433613391	5204	120	23F
0005433613446	5204	121	23E
0005432104733	5204	122	24A
0005433784321	5204	123	24B
0005433613410	5204	124	24C
0005433784294	5204	125	24E
0005433784326	5204	126	24D
0005433784298	5204	127	24F
0005433613442	5204	128	25A
0005433613406	5204	129	25C
0005433613439	5204	130	25B
0005433784320	5204	131	25D
0005433613450	5204	132	25F
0005432104737	5204	133	25E
0005433613390	5204	134	26A
0005433784302	5204	135	26B
0005433613413	5204	136	26D
0005433613434	5204	137	26C
0005433784319	5204	138	26E
0005432104716	5204	139	27A
0005432145076	5204	140	26F
0005433784306	5204	141	27C
0005432104720	5204	142	27B
0005433613389	5204	143	27D
0005432104745	5204	144	27F
0005432104719	5204	145	27E
0005433613456	5204	146	28A
0005433784307	5204	147	28B
0005432104743	5204	148	28C
0005433613402	5204	149	28E
0005433613438	5204	150	28D
0005432104724	5204	151	28F
0005433613403	5204	152	29B
0005432104739	5204	153	29A
0005433784303	5204	154	29D
0005433613447	5204	155	29C
0005433613422	5204	156	29E
0005433784310	5204	157	30A
0005432104746	5204	158	29F
0005433613387	5204	159	30B
0005433784327	5204	160	30D
0005432104754	5204	161	30C
0005433613432	5204	162	30E
0005433613449	5204	163	31A
0005432104756	5204	164	30F
0005432104730	5204	165	31B
0005433613399	5204	166	31C
0005433613428	5204	167	31D
0005433613398	5204	168	31E
0005432104721	5204	169	31F
0005434228981	5220	1	2A
0005434149531	5220	2	2D
0005434264695	5220	3	3A
0005434228967	5220	4	2F
0005434264681	5220	5	3F
0005434149528	5220	6	3D
0005434149523	5220	7	4C
0005434149527	5220	8	4D
0005434264679	5220	9	5A
0005434228969	5220	10	4F
0005434264685	5220	11	5C
0005434264686	5220	12	6A
0005434264683	5220	13	6D
0005434228979	5220	14	7A
0005434228975	5220	15	7D
0005434228977	5220	16	7C
0005434149522	5220	17	8A
0005434264693	5220	18	8C
0005434264688	5220	19	9D
0005434264680	5220	20	9F
0005434264682	5220	21	10A
0005434228984	5220	22	10C
0005434264696	5220	23	11B
0005434264694	5220	24	11E
0005434228966	5220	25	12C
0005434149526	5220	26	12E
0005434149525	5220	27	13B
0005434228973	5220	28	14C
0005434264676	5220	29	15D
0005434149524	5220	30	16B
0005434264691	5220	31	16C
0005434264690	5220	32	16F
0005434228983	5220	33	17A
0005434228987	5220	34	17C
0005434228970	5220	35	17E
0005434149530	5220	36	19B
0005434264687	5220	37	19C
0005434149521	5220	38	19E
0005434264689	5220	39	20A
0005434228985	5220	40	20C
0005434149529	5220	41	20D
0005434264692	5220	42	21D
0005434228982	5220	43	21F
0005434264678	5220	44	22A
0005434228976	5220	45	22D
0005434264697	5220	46	22C
0005434264701	5220	47	23A
0005434228974	5220	48	23B
0005434173450	5220	49	23E
0005434228986	5220	50	24B
0005434173451	5220	51	25D
0005434149520	5220	52	26C
0005434264684	5220	53	27C
0005434228968	5220	54	27F
0005434228988	5220	55	28A
0005434228980	5220	56	28E
0005434264700	5220	57	29E
