BEGIN
  FOR r IN (SELECT object_type, object_name
            FROM all_objects
            WHERE owner = 'TMT') LOOP
    EXECUTE IMMEDIATE 'DROP ' || r.object_type || ' TMT.' || r.object_name;
  END LOOP;
END;
