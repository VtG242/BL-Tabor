--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.18
-- Dumped by pg_dump version 9.4.0
-- Started on 2017-09-17 20:36:48 CEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 2313 (class 1262 OID 83905)
-- Name: BL-Tabor; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "BL-Tabor" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'cs_CZ.UTF-8' LC_CTYPE = 'cs_CZ.UTF-8';


ALTER DATABASE "BL-Tabor" OWNER TO postgres;

\connect "BL-Tabor"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 186 (class 3079 OID 12018)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2316 (class 0 OID 0)
-- Dependencies: 186
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 193 (class 1255 OID 83907)
-- Name: gethpname(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gethpname(pid integer) RETURNS character varying
    LANGUAGE sql STABLE
    AS $_$
SELECT players.psurname||' '||players.pname   
FROM players WHERE pid=$1
$_$;


ALTER FUNCTION public.gethpname(pid integer) OWNER TO postgres;

--
-- TOC entry 200 (class 1255 OID 83908)
-- Name: gethpname(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gethpname(mid integer, ppos integer) RETURNS character varying
    LANGUAGE sql STABLE
    AS $_$
SELECT players.psurname||' '||players.pname||'('||gamescore.hc||')'  
FROM players,gamescore,matches 
WHERE 
matches.mid=gamescore.gmid AND
matches.mhtid=gamescore.gtid AND
gamescore.gmid=$1 AND
gamescore.pmp=$2 AND
gamescore.gpid=players.pid
$_$;


ALTER FUNCTION public.gethpname(mid integer, ppos integer) OWNER TO postgres;

--
-- TOC entry 2317 (class 0 OID 0)
-- Dependencies: 200
-- Name: FUNCTION gethpname(mid integer, ppos integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION gethpname(mid integer, ppos integer) IS 'Zobrazi jmeno domaciho hrace pro:
mid - match ID
ppos - player match position ';


--
-- TOC entry 201 (class 1255 OID 83909)
-- Name: gethppoints(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gethppoints(mid integer, ppos integer) RETURNS integer
    LANGUAGE sql STABLE
    AS $_$
SELECT gamescore.points+gamescore.hc 
FROM gamescore,matches 
WHERE matches.mid=gamescore.gmid AND matches.mhtid=gamescore.gtid AND gamescore.gmid=$1 AND gamescore.pmp=$2
$_$;


ALTER FUNCTION public.gethppoints(mid integer, ppos integer) OWNER TO postgres;

--
-- TOC entry 2318 (class 0 OID 0)
-- Dependencies: 201
-- Name: FUNCTION gethppoints(mid integer, ppos integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION gethppoints(mid integer, ppos integer) IS 'Zobrazi body domaciho hrace pro:
mid - match ID
ppos - player match position ';


--
-- TOC entry 202 (class 1255 OID 83910)
-- Name: getmatchpoints_gd(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getmatchpoints_gd(mid integer, tid integer) RETURNS double precision
    LANGUAGE sql STABLE
    AS $_$
SELECT pointstotal
FROM endresults
WHERE emid=$1 AND etid=$2
$_$;


ALTER FUNCTION public.getmatchpoints_gd(mid integer, tid integer) OWNER TO postgres;

--
-- TOC entry 2319 (class 0 OID 0)
-- Dependencies: 202
-- Name: FUNCTION getmatchpoints_gd(mid integer, tid integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION getmatchpoints_gd(mid integer, tid integer) IS 'Zobrazi celkove body pro:
mid - match ID
tid - team ID';


--
-- TOC entry 203 (class 1255 OID 83911)
-- Name: getmatchscore_gd(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getmatchscore_gd(mid integer, tid integer) RETURNS integer
    LANGUAGE sql STABLE
    AS $_$
SELECT scoretotal
FROM endresults
WHERE emid=$1 AND etid=$2
$_$;


ALTER FUNCTION public.getmatchscore_gd(mid integer, tid integer) OWNER TO postgres;

--
-- TOC entry 2320 (class 0 OID 0)
-- Dependencies: 203
-- Name: FUNCTION getmatchscore_gd(mid integer, tid integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION getmatchscore_gd(mid integer, tid integer) IS 'Zobrazi celkove score pro:
mid - match ID
tid - team ID';


--
-- TOC entry 204 (class 1255 OID 83912)
-- Name: getplayeravg(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getplayeravg(pid integer, sid integer) RETURNS numeric
    LANGUAGE sql STABLE
    AS $_$
SELECT round (AVG(points),2) FROM gamescore WHERE gpid=$1 AND gsid=$2 
$_$;


ALTER FUNCTION public.getplayeravg(pid integer, sid integer) OWNER TO postgres;

--
-- TOC entry 2321 (class 0 OID 0)
-- Dependencies: 204
-- Name: FUNCTION getplayeravg(pid integer, sid integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION getplayeravg(pid integer, sid integer) IS 'Vrátí průměr hráče pro:
pid - player ID
sid - season ID';


--
-- TOC entry 205 (class 1255 OID 83913)
-- Name: getplayercategory_gd(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getplayercategory_gd(sex character varying, pid integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
BEGIN

  IF $2 = 21 OR $2 = 22 THEN 
    RETURN 'Junioři';
  END IF; 
  
  IF $1 = 'M' THEN
    RETURN 'Muži';
  ELSE   
    RETURN 'Ženy';
  END IF;

END;
$_$;


ALTER FUNCTION public.getplayercategory_gd(sex character varying, pid integer) OWNER TO postgres;

--
-- TOC entry 2322 (class 0 OID 0)
-- Dependencies: 205
-- Name: FUNCTION getplayercategory_gd(sex character varying, pid integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION getplayercategory_gd(sex character varying, pid integer) IS 'Vrati hracskou kategorii';


--
-- TOC entry 206 (class 1255 OID 83914)
-- Name: getplayerhc(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getplayerhc(pid integer, mid integer) RETURNS integer
    LANGUAGE sql STABLE
    AS $_$
SELECT hc   
FROM gamescore WHERE gpid=$1 AND gmid=$2
$_$;


ALTER FUNCTION public.getplayerhc(pid integer, mid integer) OWNER TO postgres;

--
-- TOC entry 207 (class 1255 OID 83915)
-- Name: getplayerpoints_gd(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getplayerpoints_gd(mid integer, pid integer, pmp integer, pscore integer) RETURNS double precision
    LANGUAGE plpgsql
    AS $_$DECLARE
p2score integer;
BEGIN
  SELECT INTO p2score (points+hc) FROM gamescore WHERE gmid=$1 AND gpid<>$2 AND gamescore.pmp=$3;
  IF $4 > p2score THEN RETURN 1;
  ELSIF $4 < p2score THEN RETURN 0;
  ELSE RETURN 0.5;  
  END IF;
END;
$_$;


ALTER FUNCTION public.getplayerpoints_gd(mid integer, pid integer, pmp integer, pscore integer) OWNER TO postgres;

--
-- TOC entry 2323 (class 0 OID 0)
-- Dependencies: 207
-- Name: FUNCTION getplayerpoints_gd(mid integer, pid integer, pmp integer, pscore integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION getplayerpoints_gd(mid integer, pid integer, pmp integer, pscore integer) IS 'Vrati pocet ziskanych bodu za hru 1 vs 1';


--
-- TOC entry 208 (class 1255 OID 83916)
-- Name: getplayerpointsbp_gd(character varying, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getplayerpointsbp_gd(mbp character varying, mid integer, pid integer, pscore integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$DECLARE

p2 integer;
p2score integer;
home integer;
visit integer;

BEGIN

  IF $1 = 'Y' THEN
   
    SELECT INTO home bphplayer FROM bp WHERE bpmid=$2;
    SELECT INTO visit bpvplayer FROM bp WHERE bpmid=$2;
    
    IF home=$3 OR visit=$3 THEN
     IF home=$3
       THEN p2=visit;
       ELSE p2=home;
     END IF;
    ELSE 
      RETURN 0;
    END IF;
    
    SELECT INTO p2score (points+hc) FROM gamescore WHERE gmid=$2 AND gpid=p2;

  ELSE 
  
    RETURN 0;
    
  END IF;
        
  IF $4 > p2score THEN RETURN 2;
  ELSIF $4 < p2score THEN RETURN 0;
  ELSE RETURN 0;  
  END IF;
  
END;
$_$;


ALTER FUNCTION public.getplayerpointsbp_gd(mbp character varying, mid integer, pid integer, pscore integer) OWNER TO postgres;

--
-- TOC entry 2324 (class 0 OID 0)
-- Dependencies: 208
-- Name: FUNCTION getplayerpointsbp_gd(mbp character varying, mid integer, pid integer, pscore integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION getplayerpointsbp_gd(mbp character varying, mid integer, pid integer, pscore integer) IS 'Vrati pocet ziskanych bodu za hru s cernym Petrem';


--
-- TOC entry 209 (class 1255 OID 83917)
-- Name: getplayerposition(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getplayerposition(mid integer, pid integer) RETURNS integer
    LANGUAGE sql STABLE
    AS $_$
SELECT pmp FROM gamescore WHERE gmid=$1 AND gpid=$2
$_$;


ALTER FUNCTION public.getplayerposition(mid integer, pid integer) OWNER TO postgres;

--
-- TOC entry 2325 (class 0 OID 0)
-- Dependencies: 209
-- Name: FUNCTION getplayerposition(mid integer, pid integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION getplayerposition(mid integer, pid integer) IS 'Zobrazi pozici hrace pro:
mid - match ID
pid - player ID';


--
-- TOC entry 210 (class 1255 OID 83918)
-- Name: getteamname(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getteamname(tid integer) RETURNS character varying
    LANGUAGE sql STABLE
    AS $_$
SELECT tname FROM teams WHERE tid=$1
$_$;


ALTER FUNCTION public.getteamname(tid integer) OWNER TO postgres;

--
-- TOC entry 211 (class 1255 OID 83919)
-- Name: getteampoints_gd(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getteampoints_gd(mid integer, tid integer, tscore integer) RETURNS double precision
    LANGUAGE plpgsql
    AS $_$DECLARE
t2score integer;
BEGIN
  SELECT INTO t2score scoretotal FROM endresults WHERE emid=$1 AND etid<>$2;
  IF $3 > t2score THEN RETURN 2;
  ELSIF $3 < t2score THEN RETURN 0;
  ELSE RETURN 1;  
  END IF;
END;
$_$;


ALTER FUNCTION public.getteampoints_gd(mid integer, tid integer, tscore integer) OWNER TO postgres;

--
-- TOC entry 2326 (class 0 OID 0)
-- Dependencies: 211
-- Name: FUNCTION getteampoints_gd(mid integer, tid integer, tscore integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION getteampoints_gd(mid integer, tid integer, tscore integer) IS 'Vrati pocet ziskanych bodu za tym';


--
-- TOC entry 212 (class 1255 OID 83920)
-- Name: gettotalpoints(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gettotalpoints(mid integer, tid integer) RETURNS double precision
    LANGUAGE sql STABLE
    AS $_$
SELECT pointstotal FROM endresults WHERE emid=$1 AND etid=$2
$_$;


ALTER FUNCTION public.gettotalpoints(mid integer, tid integer) OWNER TO postgres;

--
-- TOC entry 213 (class 1255 OID 83921)
-- Name: getvpname(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getvpname(mid integer, ppos integer) RETURNS character varying
    LANGUAGE sql STABLE
    AS $_$
SELECT players.psurname||' '||players.pname||'('||gamescore.hc||')'  
FROM players,gamescore,matches 
WHERE 
matches.mid=gamescore.gmid AND
matches.mvtid=gamescore.gtid AND
gamescore.gmid=$1 AND
gamescore.pmp=$2 AND
gamescore.gpid=players.pid
$_$;


ALTER FUNCTION public.getvpname(mid integer, ppos integer) OWNER TO postgres;

--
-- TOC entry 2327 (class 0 OID 0)
-- Dependencies: 213
-- Name: FUNCTION getvpname(mid integer, ppos integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION getvpname(mid integer, ppos integer) IS 'Zobrazi jmeno hostujiciho hrace pro:
mid - match ID
ppos - player match position ';


--
-- TOC entry 214 (class 1255 OID 83922)
-- Name: getvppoints(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getvppoints(mid integer, ppos integer) RETURNS integer
    LANGUAGE sql STABLE
    AS $_$
SELECT gamescore.points+gamescore.hc
FROM gamescore,matches 
WHERE matches.mid=gamescore.gmid AND matches.mvtid=gamescore.gtid AND gamescore.gmid=$1 AND gamescore.pmp=$2
$_$;


ALTER FUNCTION public.getvppoints(mid integer, ppos integer) OWNER TO postgres;

--
-- TOC entry 2328 (class 0 OID 0)
-- Dependencies: 214
-- Name: FUNCTION getvppoints(mid integer, ppos integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION getvppoints(mid integer, ppos integer) IS 'Zobrazi body domaciho hrace pro:
mid - match ID
ppos - player match position ';


--
-- TOC entry 215 (class 1255 OID 83923)
-- Name: pocetradku(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pocetradku() RETURNS integer
    LANGUAGE plpgsql
    AS $$
  DECLARE hp int;
  DECLARE vp int;
  DECLARE r int;
  
  BEGIN
    SELECT INTO hp points FROM gamescore WHERE gamescore.gmid=1 AND gamescore.gtid=1 AND pmp=1;
    SELECT INTO vp points FROM gamescore WHERE gamescore.gmid=1 AND gamescore.gtid=2 AND pmp=1;
    
    IF hp=vp THEN 
      r=1;
    END IF;
    IF hp>vp THEN 
      r=1;
      ELSE
      r=0;
    END IF;
    
    RETURN r;
  END;
$$;


ALTER FUNCTION public.pocetradku() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = true;

--
-- TOC entry 170 (class 1259 OID 83924)
-- Name: bp; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE bp (
    bpmid integer NOT NULL,
    bphplayer integer NOT NULL,
    bpvplayer integer NOT NULL
);


ALTER TABLE bp OWNER TO postgres;

--
-- TOC entry 171 (class 1259 OID 83927)
-- Name: endresults; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE endresults (
    esid integer NOT NULL,
    erid integer NOT NULL,
    emid integer NOT NULL,
    etid integer NOT NULL,
    scoretotal integer DEFAULT 0 NOT NULL,
    points1 double precision DEFAULT 0 NOT NULL,
    points2 double precision DEFAULT 0 NOT NULL,
    points3 double precision DEFAULT 0 NOT NULL,
    pointstotal double precision DEFAULT 0 NOT NULL
);


ALTER TABLE endresults OWNER TO postgres;

--
-- TOC entry 172 (class 1259 OID 83935)
-- Name: gamescore; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE gamescore (
    gmid integer NOT NULL,
    gtid integer NOT NULL,
    gpid integer NOT NULL,
    pmp integer NOT NULL,
    hc integer DEFAULT 0,
    points integer NOT NULL,
    gsid integer NOT NULL,
    CONSTRAINT pmp_chk CHECK (((pmp >= 1) AND (pmp <= 3))),
    CONSTRAINT points_chk CHECK (((points >= 0) AND (points <= 300)))
);


ALTER TABLE gamescore OWNER TO postgres;

--
-- TOC entry 2329 (class 0 OID 0)
-- Dependencies: 172
-- Name: TABLE gamescore; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE gamescore IS 'bpmid - Black Peter match id
bphplayer - home player ID as Black Peter
bpvplayer - visitor player ID as Black Peter';


--
-- TOC entry 173 (class 1259 OID 83941)
-- Name: lid_sq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE lid_sq
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE lid_sq OWNER TO postgres;

--
-- TOC entry 2330 (class 0 OID 0)
-- Dependencies: 173
-- Name: SEQUENCE lid_sq; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON SEQUENCE lid_sq IS 'League ID sequence';


SET default_with_oids = false;

--
-- TOC entry 174 (class 1259 OID 83943)
-- Name: leagues; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE leagues (
    lid integer DEFAULT nextval('lid_sq'::regclass) NOT NULL,
    lname character varying(100) NOT NULL,
    lshort character varying(10) NOT NULL
);


ALTER TABLE leagues OWNER TO postgres;

SET default_with_oids = true;

--
-- TOC entry 175 (class 1259 OID 83947)
-- Name: lineups; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE lineups (
    lsid integer NOT NULL,
    ltid integer NOT NULL,
    lpid integer NOT NULL,
    llid integer NOT NULL
);


ALTER TABLE lineups OWNER TO postgres;

--
-- TOC entry 176 (class 1259 OID 83950)
-- Name: mid_sq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE mid_sq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mid_sq OWNER TO postgres;

--
-- TOC entry 2331 (class 0 OID 0)
-- Dependencies: 176
-- Name: SEQUENCE mid_sq; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON SEQUENCE mid_sq IS 'Match ID sequence';


SET default_with_oids = false;

--
-- TOC entry 177 (class 1259 OID 83952)
-- Name: matches; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE matches (
    mid integer DEFAULT nextval('mid_sq'::regclass) NOT NULL,
    msid integer NOT NULL,
    mrid integer NOT NULL,
    mhtid integer NOT NULL,
    mvtid integer NOT NULL,
    bp character(1) DEFAULT 'N'::bpchar NOT NULL,
    CONSTRAINT bp_chk CHECK (((bp = 'Y'::bpchar) OR (bp = 'N'::bpchar)))
);


ALTER TABLE matches OWNER TO postgres;

--
-- TOC entry 2332 (class 0 OID 0)
-- Dependencies: 177
-- Name: TABLE matches; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE matches IS 'mid - match ID
msid - match session ID
mrid - match round ID
mhtid - match home team ID
mvtid - match visitor team ID';


--
-- TOC entry 178 (class 1259 OID 83958)
-- Name: pid_sq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE pid_sq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pid_sq OWNER TO postgres;

--
-- TOC entry 2333 (class 0 OID 0)
-- Dependencies: 178
-- Name: SEQUENCE pid_sq; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON SEQUENCE pid_sq IS 'Player ID sequence';


--
-- TOC entry 179 (class 1259 OID 83960)
-- Name: players; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE players (
    pid integer DEFAULT nextval('pid_sq'::regclass) NOT NULL,
    pname character varying(20) NOT NULL,
    psurname character varying(40) NOT NULL,
    pgender character(1) NOT NULL,
    CONSTRAINT pgender_chk CHECK (((pgender = 'M'::bpchar) OR (pgender = 'F'::bpchar)))
);


ALTER TABLE players OWNER TO postgres;

--
-- TOC entry 180 (class 1259 OID 83965)
-- Name: rid_sq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE rid_sq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rid_sq OWNER TO postgres;

--
-- TOC entry 2334 (class 0 OID 0)
-- Dependencies: 180
-- Name: SEQUENCE rid_sq; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON SEQUENCE rid_sq IS 'Round ID sequence';


--
-- TOC entry 181 (class 1259 OID 83967)
-- Name: rounds; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE rounds (
    rid integer DEFAULT nextval('rid_sq'::regclass) NOT NULL,
    rsid integer NOT NULL,
    rname character varying(100) NOT NULL,
    rdate date NOT NULL,
    rlid integer NOT NULL
);


ALTER TABLE rounds OWNER TO postgres;

--
-- TOC entry 182 (class 1259 OID 83971)
-- Name: sid_sq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sid_sq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sid_sq OWNER TO postgres;

--
-- TOC entry 2335 (class 0 OID 0)
-- Dependencies: 182
-- Name: SEQUENCE sid_sq; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON SEQUENCE sid_sq IS 'Season ID sequence';


--
-- TOC entry 183 (class 1259 OID 83973)
-- Name: seasons; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE seasons (
    sid integer DEFAULT nextval('sid_sq'::regclass) NOT NULL,
    sname character varying(100) NOT NULL
);


ALTER TABLE seasons OWNER TO postgres;

--
-- TOC entry 184 (class 1259 OID 83977)
-- Name: tid_sq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tid_sq
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tid_sq OWNER TO postgres;

--
-- TOC entry 2336 (class 0 OID 0)
-- Dependencies: 184
-- Name: SEQUENCE tid_sq; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON SEQUENCE tid_sq IS 'Team ID sequence';


--
-- TOC entry 185 (class 1259 OID 83979)
-- Name: teams; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE teams (
    tid integer DEFAULT nextval('tid_sq'::regclass) NOT NULL,
    tname character varying(100) NOT NULL
);


ALTER TABLE teams OWNER TO postgres;

--
-- TOC entry 2170 (class 2606 OID 105397)
-- Name: lid_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY leagues
    ADD CONSTRAINT lid_pk PRIMARY KEY (lid);


--
-- TOC entry 2172 (class 2606 OID 105399)
-- Name: mid_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY matches
    ADD CONSTRAINT mid_pk PRIMARY KEY (mid);


--
-- TOC entry 2174 (class 2606 OID 105401)
-- Name: pid_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY players
    ADD CONSTRAINT pid_pk PRIMARY KEY (pid);


--
-- TOC entry 2176 (class 2606 OID 105403)
-- Name: rid_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rounds
    ADD CONSTRAINT rid_pk PRIMARY KEY (rid);


--
-- TOC entry 2178 (class 2606 OID 105405)
-- Name: sid_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY seasons
    ADD CONSTRAINT sid_pk PRIMARY KEY (sid);


--
-- TOC entry 2180 (class 2606 OID 105407)
-- Name: tid_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT tid_pk PRIMARY KEY (tid);


--
-- TOC entry 2181 (class 2606 OID 105408)
-- Name: bphplayer_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY bp
    ADD CONSTRAINT bphplayer_fk FOREIGN KEY (bphplayer) REFERENCES players(pid);


--
-- TOC entry 2182 (class 2606 OID 105413)
-- Name: bpmid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY bp
    ADD CONSTRAINT bpmid_fk FOREIGN KEY (bpmid) REFERENCES matches(mid);


--
-- TOC entry 2183 (class 2606 OID 105418)
-- Name: bpvplayer_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY bp
    ADD CONSTRAINT bpvplayer_fk FOREIGN KEY (bpvplayer) REFERENCES players(pid);


--
-- TOC entry 2184 (class 2606 OID 105423)
-- Name: emid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY endresults
    ADD CONSTRAINT emid_fk FOREIGN KEY (emid) REFERENCES matches(mid);


--
-- TOC entry 2185 (class 2606 OID 105428)
-- Name: erid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY endresults
    ADD CONSTRAINT erid_fk FOREIGN KEY (erid) REFERENCES rounds(rid);


--
-- TOC entry 2186 (class 2606 OID 105433)
-- Name: esid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY endresults
    ADD CONSTRAINT esid_fk FOREIGN KEY (esid) REFERENCES seasons(sid);


--
-- TOC entry 2187 (class 2606 OID 105438)
-- Name: etid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY endresults
    ADD CONSTRAINT etid_fk FOREIGN KEY (etid) REFERENCES teams(tid);


--
-- TOC entry 2188 (class 2606 OID 105443)
-- Name: gmid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY gamescore
    ADD CONSTRAINT gmid_fk FOREIGN KEY (gmid) REFERENCES matches(mid);


--
-- TOC entry 2189 (class 2606 OID 105448)
-- Name: gpid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY gamescore
    ADD CONSTRAINT gpid_fk FOREIGN KEY (gpid) REFERENCES players(pid);


--
-- TOC entry 2190 (class 2606 OID 105453)
-- Name: gsid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY gamescore
    ADD CONSTRAINT gsid_fk FOREIGN KEY (gsid) REFERENCES seasons(sid);


--
-- TOC entry 2191 (class 2606 OID 105458)
-- Name: gtid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY gamescore
    ADD CONSTRAINT gtid_fk FOREIGN KEY (gtid) REFERENCES teams(tid);


--
-- TOC entry 2192 (class 2606 OID 105463)
-- Name: llid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY lineups
    ADD CONSTRAINT llid_fk FOREIGN KEY (llid) REFERENCES leagues(lid);


--
-- TOC entry 2193 (class 2606 OID 105468)
-- Name: lpid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY lineups
    ADD CONSTRAINT lpid_fk FOREIGN KEY (lpid) REFERENCES players(pid);


--
-- TOC entry 2194 (class 2606 OID 105473)
-- Name: lsid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY lineups
    ADD CONSTRAINT lsid_fk FOREIGN KEY (lsid) REFERENCES seasons(sid);


--
-- TOC entry 2195 (class 2606 OID 105478)
-- Name: ltid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY lineups
    ADD CONSTRAINT ltid_fk FOREIGN KEY (ltid) REFERENCES teams(tid);


--
-- TOC entry 2196 (class 2606 OID 105483)
-- Name: mhtid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY matches
    ADD CONSTRAINT mhtid_fk FOREIGN KEY (mhtid) REFERENCES teams(tid);


--
-- TOC entry 2197 (class 2606 OID 105488)
-- Name: mrid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY matches
    ADD CONSTRAINT mrid_fk FOREIGN KEY (mrid) REFERENCES rounds(rid);


--
-- TOC entry 2198 (class 2606 OID 105493)
-- Name: msid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY matches
    ADD CONSTRAINT msid_fk FOREIGN KEY (msid) REFERENCES seasons(sid);


--
-- TOC entry 2199 (class 2606 OID 105498)
-- Name: mvtid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY matches
    ADD CONSTRAINT mvtid_fk FOREIGN KEY (mvtid) REFERENCES teams(tid);


--
-- TOC entry 2200 (class 2606 OID 105503)
-- Name: rlid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rounds
    ADD CONSTRAINT rlid_fk FOREIGN KEY (rlid) REFERENCES leagues(lid);


--
-- TOC entry 2201 (class 2606 OID 105508)
-- Name: rsid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rounds
    ADD CONSTRAINT rsid_fk FOREIGN KEY (rsid) REFERENCES seasons(sid);


--
-- TOC entry 2315 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2017-09-17 20:36:48 CEST

--
-- PostgreSQL database dump complete
--

