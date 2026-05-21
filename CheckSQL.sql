select * from  CUSTOMERDATA.EPSEWERAI_WOT_STG 
--where workclassifi_oi is null
--where FEED_STATUS = 'NEW'
where WONUMBER = '280798'
order by WONUMBER desc

select * from  CUSTOMERDATA.EPSEWERAI_WOT_STG1 
where WORKORDER_UUID = '319A99C62E2733488E084BF759890479'
order by WONUMBER desc

DELETE FROM CUSTOMERDATA.EPSEWERAI_WOT_STG
where workclassifi_oi is null

where WORKORDER_UUID = '58F1333855AAB34EBDCFBF627E5E7D34'

update CUSTOMERDATA.EPSEWERAI_WOT_STG set FEED_STATUS = 'NEW'
where WORKORDER_UUID = '319A99C62E2733488E084BF759890479'

UPDATE CUSTOMERDATA.EPSEWERAI_WOT_STG 
SET PLNDSTRTDATE_DTTM = PLNDSTRTDATE_DTTM + 1
WHERE WONUMBER = '247310';

select * from MNT.ASSET
where title = 'Mechanic Shop Consumables'

SELECT * from CUSTOMERDATA.EPSEWERAI_CR_INSPECT
where WORKORDER = '283772.1'

update CUSTOMERDATA.EPSEWERAI_CR_INSPECT set FEED_STATUS = 'NEW'
where WORK_ORDER_UUID = 'a02d6812-95cb-4545-9b9a-28ba10db0f00'
AND INSPECTION_TYPE = 'PACP'
AND WORKORDER = '212393.1'

commit

select * from  CUSTOMERDATA.EPSEWERAI_CR_INSPECT  
--where PO_NUMBER = '1020537'
--and PROJECT_SID IS  NULL
--AND INSPECTION_SID IS NULL

where workorder = '280798.1'
and task_uuid = '037943A29D07914FAD76E2A742F932B5'

select * from CUSTOMERDATA.EPSEWERAI_WOT_STG
WHERE "FEED_STATUS" <> 'SENT';

select * from CUSTOMERDATA.EPSEWERAI_WOT_STG1

SELECT * From CUSTOMERDATA.V_CR_INSPECT_TO_SEND     --small few rows to send


SELECT * From CUSTOMERDATA.SEWERAI_INSPECTIONS_V 
-where ASSET_NUMBER = '1195290'-- all rows
where WORK_ORDERS_NUMBER like '283772.1%'
order by 1 desc


SELECT * From CUSTOMERDATA.EPSEWERAI_CR_INSPECT  
where workorder = '247310.1'

--Where PO_Number like  '1020531%'



UPATE "FEED_STATUS" = 'NEW';
--where PIPE_SEGMENT_REFERENCE = '102149'
order by WORKORDER DESC

SELECT * From CUSTOMERDATA.EPSEWERAI_CR_INSPECT  
WHERE "FEED_STATUS" <> 'SENT';

UPDATE CUSTOMERDATA.EPSEWERAI_CR_INSPECT 
--big trigger scripts
UPDATE CUSTOMERDATA.EPSEWERAI_CR_INSPECT  SET FEED_STATUS = 'NEW'
where workorder = '247310.1'
COMMIT


UPDATE CUSTOMERDATA.EPSEWERAI_WOT_STG
SET    FEED_STATUS = 'SENT'
WHERE  TASK_UUID = HEXTORAW('9860712058EEFA45B10ABF218E01AA7D')
--WHERE  WORKORDER_UUID = HEXTORAW('76A3D51F58581443AF278F00E0E6762F')

COMMIT;








SELECT wo.WORKORDERSOI, wo.SITE_OI
FROM MNT.WORKORDERS wo
WHERE wo.WORKORDERSOI IN (876842)
;

SELECT *
FROM MNT.WORKORDERTASK
WHERE WORKORDER_OI IN (876842)
;



SELECT status, description 
FROM user_triggers
WHERE trigger_name = 'TRG_WOT_TO_STG';


SELECT object_name, timestamp
FROM user_objects
WHERE object_name = 'TRG_WOT_TO_STG';


SELECT segment_name, segment_type, buffer_pool, blocks
FROM dba_segments
WHERE segment_name = 'WORKORDERTASK';

SELECT DISTINCT ora_rowscn
FROM MNT.WORKORDERTASK
WHERE workorder_oi = 876842;



SELECT column_name
FROM all_tab_columns
WHERE table_name = 'EPSEWERAI_WOT_STG';


select * from mnt.asset 
where assetnumber = '1195313'
and WORKCLASSIFI_OI = '462'

SELECT *
FROM CUSTOMERDATA."EPSEWERAI_CR_INSPECT" tgt
WHERE NOT EXISTS (
  SELECT 1
  FROM CUSTOMERDATA."SEWERAI_INSPECTIONS_V" v
  WHERE LOWER(
          REGEXP_REPLACE(
            REGEXP_REPLACE(NVL(v."DR_UUID", ''), '[^0-9A-Fa-f]', ''),
            '(^[0-9A-Fa-f]{8})([0-9A-Fa-f]{4})([0-9A-Fa-f]{4})([0-9A-Fa-f]{4})([0-9A-Fa-f]{12}$)',
            '\1-\2-\3-\4-\5'
          )
        ) = tgt."INSPECTIONID"
);



DELETE FROM CUSTOMERDATA."EPSEWERAI_CR_INSPECT" tgt
WHERE NOT EXISTS (
  SELECT 1
  FROM CUSTOMERDATA."SEWERAI_INSPECTIONS_V" v
  WHERE LOWER(
          REGEXP_REPLACE(
            REGEXP_REPLACE(NVL(v."DR_UUID", ''), '[^0-9A-Fa-f]', ''),
            '(^[0-9A-Fa-f]{8})([0-9A-Fa-f]{4})([0-9A-Fa-f]{4})([0-9A-Fa-f]{4})([0-9A-Fa-f]{12}$)',
            '\1-\2-\3-\4-\5'
          )
        ) = tgt."INSPECTIONID"
);
COMMIT;


  





-- ***Number 1 to Check if EM Agent connections are failing during the listener handshake
SELECT *
FROM   v$listener_network


PROMPT === INSTANCE STATUS ===
SELECT instance_name, status, database_status, logins, startup_time 
FROM v$instance;

PROMPT === ACTIVE SESSIONS ===
SELECT status, COUNT(*) 
FROM v$session 
WHERE type='USER'
GROUP BY status;


PROMPT === ALERT LOG ERRORS (24H) ===
SELECT originating_timestamp, message_text
FROM v$diag_alert_ext
WHERE originating_timestamp > SYSDATE - 1
  AND LOWER(message_text) LIKE '%error%';
  
  
--Check for connection timeouts / EM Agent failed login attempts (from alert log)
SELECT originating_timestamp, message_text
FROM   v$diag_alert_ext
WHERE  originating_timestamp > SYSDATE - 1
  AND (LOWER(message_text) LIKE '%tns-12170%'
    OR LOWER(message_text) LIKE '%fatal ni%'
    OR LOWER(message_text) LIKE '%agent%'
    OR LOWER(message_text) LIKE '%timeout%')
ORDER BY originating_timestamp DESC;


-- Check for long-running or hung sessions (which EM reports as “DB unresponsive”)
SELECT event, total_waits, time_waited
FROM   v$system_event
WHERE  LOWER(event) LIKE '%enqueue%'
    OR LOWER(event) LIKE '%latch%'
    OR LOWER(event) LIKE '%row lock%'
ORDER BY time_waited DESC;

--Check who is connecting to the database (sessions)
SELECT
    username,
    machine,
    program,
    module,
    status,
    COUNT(*) AS sessions
FROM v$session
GROUP BY username, machine, program, module, status
ORDER BY sessions DESC;

PROMPT === INVALID OBJECTS ===
SELECT owner, object_type, COUNT(*) 
FROM dba_objects 
WHERE status='INVALID'
GROUP BY owner, object_type;

PROMPT === TABLESPACE USAGE ===
SELECT df.tablespace_name,
       ROUND(df.total_mb, 1) AS total_mb,
       ROUND(df.total_mb - fs.free_mb, 1) AS used_mb,
       ROUND(fs.free_mb, 1) AS free_mb,
       ROUND((fs.free_mb/df.total_mb)*100, 1) AS pct_free
FROM (SELECT tablespace_name, SUM(bytes)/1024/1024 total_mb 
      FROM dba_data_files GROUP BY tablespace_name) df
JOIN (SELECT tablespace_name, SUM(bytes)/1024/1024 free_mb 
      FROM dba_free_space GROUP BY tablespace_name) fs
  ON df.tablespace_name = fs.tablespace_name;

-- Sessions that experienced a deadlock in the last 24 hours
SELECT
  TO_CHAR(sample_time, 'YYYY-MM-DD HH24:MI:SS') AS sample_time,
  session_id AS sid,
  session_serial# AS serial#,
  user_id,
  session_state,
  event,
  sql_id,
  blocking_session
FROM dba_hist_active_sess_history
WHERE sample_time >= SYSTIMESTAMP - INTERVAL '24' HOUR
  AND LOWER(event) LIKE '%deadlock%'
ORDER BY sample_time DESC;


-- RAC-safe (GV$) version. For single-instance you can replace GV$ with V$.
-- Shows recent alert messages with 'deadlock'
-- Where to look for trace files:
SELECT value AS diagnostic_dest FROM v$parameter WHERE name = 'diagnostic_dest';

-- Recent trace files (names). The deadlock will be in a process/session trace generated at the time of deadlock.
SELECT * FROM v$diag_info;  -- includes 'Diag Trace' directory path



SELECT
  job_name,
  enabled,
  state
FROM all_scheduler_jobs
WHERE job_name = 'SEWERAI_SYNC_FEEDSTATUS_JOB';

SELECT
  job_name,
  last_start_date,
  last_run_duration,
  next_run_date
FROM all_scheduler_jobs
WHERE job_name = 'SEWERAI_SYNC_FEEDSTATUS_JOB';

SELECT
  log_date,
  status,
  additional_info,
  errors
FROM all_scheduler_job_run_details
WHERE job_name = 'SEWERAI_SYNC_FEEDSTATUS_JOB'
ORDER BY log_date DESC;


SELECT
  wo.WONUMBER                                         AS wonumber,
  a.UUID                                              AS workorder_uuid,
  t.UUID                                              AS task_uuid,
  t.TASKNUMBER                                        AS tasknumber,

  -- Prefer task title; fallback to WO title
  a.title                                             AS wotasktitle,

  -- Planned completion comes from WORKORDERS only
  wo.REQCOMPDATE_DTTM                                 AS plndcompdate_dttm,

  -- Prefer task-level start; fallback to WO-level
  NVL(t.PLNDSTRTDATE_DTTM, wo.PLNDSTRTDATE_DTTM)      AS plndstrtdate_dttm,

  -- Use the actual classification (NO defaulting to 209)
  t.WORKCLASSIFI_OI                                   AS workclassifi_oi

FROM MNT.WORKORDERTASK t
INNER JOIN MNT.WORKORDERS wo ON wo.WORKORDERSOI = t.WORKORDER_OI
INNER JOIN MNT.ASSET a ON t.ASSET_OI = a.ASSETOI
WHERE wo.SITE_OI = 58
  AND t.LASTUPDATE_DTTM >= SYSDATE - (5/1440)
  AND t.WORKCLASSIFI_OI IN (
        209, 211, 215, 266, 442, 462,
        183, 196, 207, 256, 263
      );
      
      
      
      
    SELECT s.sid, s.serial#, t.start_time
FROM   v$session s
JOIN   v$transaction t ON s.saddr = t.ses_addr
WHERE  s.username = USER;


SELECT s.sid,
       s.serial#,
       s.username,
       s.program,
       t.start_time
FROM   v$session s
JOIN   v$transaction t ON s.saddr = t.ses_addr
WHERE  s.username = USER;



SELECT o.object_name,
       o.object_type
FROM   v$locked_object lo
JOIN   dba_objects o ON lo.object_id = o.object_id
WHERE  lo.session_id = SYS_CONTEXT('USERENV','SID');