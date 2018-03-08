-- DROP FUNCTION getteampoints_gd(integer, integer, integer);

CREATE OR REPLACE FUNCTION getteampoints_gd(
    mid integer,
    tid integer,
    tscore integer)
  RETURNS double precision AS
$BODY$DECLARE
t2score integer;
BEGIN
  SELECT INTO t2score scoretotal FROM endresults WHERE emid=$1 AND etid<>$2;
  IF $3 > t2score THEN RETURN 2;
  ELSIF $3 < t2score THEN RETURN 0;
  ELSE RETURN 1;  
  END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getteampoints_gd(integer, integer, integer)
  OWNER TO postgres;
COMMENT ON FUNCTION getteampoints_gd(integer, integer, integer) IS 'Vrati pocet ziskanych bodu za tym';
