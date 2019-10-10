--------------------------------------------------------------
------ RESERVE 용

INSERT INTO RESERVE VALUES (
    SEQ_RES_NO.NEXTVAL, 'testBillingKey', 1000, TO_DATE('2019-09-23 12:00:00','YYYY-MM-DD HH24:MI:SS'), 
    '배송이름', '01000000000', '01010,서울시 중구,다동', '이렇게저렇게 해주세요', 24, 54, 1
);

INSERT INTO RESERVE VALUES (
    SEQ_RES_NO.NEXTVAL, 'testBillingKey2', 50000, TO_DATE('2019-09-23 12:00:00','YYYY-MM-DD HH24:MI:SS'), 
    '배송이름2', '01000000002', '01010,서울시 중구,다동', '이렇게저렇게 해주세요', 25, 54
);

INSERT INTO RESERVE VALUES (
    SEQ_RES_NO.NEXTVAL, 'testBillingKey3', 50000, TO_DATE('2019-09-23 12:00:00','YYYY-MM-DD HH24:MI:SS'), 
    '배송이름2', '01000000002', '01010,서울시 중구,다동', '이렇게저렇게 해주세요', 25, 54
);

INSERT INTO RESERVE VALUES (
    SEQ_RES_NO.NEXTVAL, 'testBillingKey4', 0, TO_DATE('2019-09-24 12:00:00','YYYY-MM-DD HH24:MI:SS'), 
    '이름', '01000000004', '01010,서울시 중구,다동', '배송요청사항', 30, 54, DEFAULT
);


INSERT INTO HISTORY VALUES (
 4, 5, 1
);

COMMIT;

-- HISTORY 테이블에도 추가
INSERT INTO HISTORY VALUES (
    3, 2, 1
);


--각 예약 번호별 리워드 금액 합계 조회하는 뷰
CREATE OR REPLACE VIEW RES_SUM AS
SELECT RESERVE_NO, SUM(REWARD_PRICE * REWARD_SUM) AS REWARD_PRICE_SUM FROM HISTORY
JOIN REWARD USING ( REWARD_NO )
GROUP BY RESERVE_NO
;

SELECT * FROM RES_SUM;

-- RESERVE 테이블 + 각 결제 별 금액 합계 같이 조회 해보기 + 추가 후원금까지 같이 출력
CREATE OR REPLACE VIEW RESERVE_VIEW AS
SELECT R.* , S.REWARD_PRICE_SUM, R.ADDITIONAL+S.REWARD_PRICE_SUM AS TOTAL
FROM RESERVE R
JOIN RES_SUM S ON (R.RESERVE_NO=S.RESERVE_NO);

SELECT * FROM RESERVE_VIEW;

CREATE OR REPLACE VIEW PROJECT_DETAIL_VIEW_2ND AS
SELECT PT."PROJECT_NO",PT."PROJECT_TITLE",PT."PROJECT_STITLE",PT."PROJECT_GOAL",PT."PROJECT_THUMB_IMG",PT."PROJECT_START_DT",PT."PROJECT_CLOSE_DT",PT."PROJECT_HASHTAG",PT."PROJECT_MAIN_IMG",PT."PROJECT_SUMMARY",PT."PROJECT_STORY",PT."PROJECT_AT_NM",PT."PROJECT_AT_PF",PT."PROJECT_AT_SNS1",PT."PROJECT_AT_SNS2",PT."PROJECT_AT_CONT",PT."PROJECT_AT_EM",PT."PROJECT_ER_DT",PT."PROJECT_MF_DT",PT."PROJECT_WRITER",PT."PROJECT_CT_NO",PT."PROJECT_ST_NO",PT."PROJECT_COUNT", FLOOR(PROJECT_CLOSE_DT - SYSDATE) AS D_DAY, (SELECT COUNT(*) FROM PROJECT_TB P JOIN USER_TB U ON( U.USER_NO = P. PROJECT_WRITER) WHERE P. PROJECT_WRITER = PT.PROJECT_WRITER ) "PROJECT_OPEN_COUNT",
NVL((SELECT SUM(TOTAL) FROM RESERVE_VIEW V WHERE V.RESERVE_REF_PNO = PT.PROJECT_NO GROUP BY RESERVE_REF_PNO), 0) AS TOTAL, cg.project_ct_name
FROM PROJECT_TB PT
JOIN USER_TB U ON( U.USER_NO = PT. PROJECT_WRITER)
JOIN PROJECT_CG CG ON ( PT.PROJECT_CT_NO = CG.PROJECT_CT_NO);

-- 각 프로젝트별 결제금액을 같이 프린트 해볼까?
-- 왜 이렇게 한번에 잘 되는거야 나는 천재인가
CREATE OR REPLACE VIEW PROJECT_LIST_VIEW AS
SELECT P.*, C.PROJECT_CT_NAME, FLOOR(PROJECT_CLOSE_DT - SYSDATE) AS D_DAY, NVL((SELECT SUM(TOTAL) FROM RESERVE_VIEW V WHERE V.RESERVE_REF_PNO = P.PROJECT_NO AND V.RESERVE_STATUS_NO IN (1,2,4) GROUP BY RESERVE_REF_PNO),0) AS TOTAL, (CASE WHEN PROJECT_CLOSE_DT < SYSDATE THEN NULL ELSE PROJECT_COUNT END) AS COUNTCOUNT, (SELECT COUNT(DISTINCT(HIS.RESERVE_NO)) FROM HISTORY HIS JOIN RESERVE RES ON ( HIS.RESERVE_NO = RES.RESERVE_NO ) WHERE RES.RESERVE_REF_PNO = P.PROJECT_NO ) AS SUPPORTCOUNT
FROM PROJECT_TB P
JOIN PROJECT_CG C ON ( P.PROJECT_CT_NO = C.PROJECT_CT_NO )
WHERE PROJECT_ST_NO IN ( 4, 5, 7 )
ORDER BY COUNTCOUNT DESC NULLS LAST;

  CREATE OR REPLACE FORCE VIEW PROJECT_LIST_VIEW ("PROJECT_NO", "PROJECT_TITLE", "PROJECT_STITLE", "PROJECT_GOAL", "PROJECT_THUMB_IMG", "PROJECT_START_DT", "PROJECT_CLOSE_DT", "PROJECT_HASHTAG", "PROJECT_MAIN_IMG", "PROJECT_SUMMARY", "PROJECT_STORY", "PROJECT_AT_NM", "PROJECT_AT_PF", "PROJECT_AT_SNS1", "PROJECT_AT_SNS2", "PROJECT_AT_CONT", "PROJECT_AT_EM", "PROJECT_ER_DT", "PROJECT_MF_DT", "PROJECT_WRITER", "PROJECT_CT_NO", "PROJECT_ST_NO", "PROJECT_COUNT", "PROJECT_AT_INT", "PROJECT_CT_NAME", "D_DAY", "TOTAL", "COUNTCOUNT", "SUPPORT_COUNT") AS 
  SELECT P."PROJECT_NO",P."PROJECT_TITLE",P."PROJECT_STITLE",P."PROJECT_GOAL",P."PROJECT_THUMB_IMG",P."PROJECT_START_DT",P."PROJECT_CLOSE_DT",P."PROJECT_HASHTAG",P."PROJECT_MAIN_IMG",P."PROJECT_SUMMARY",P."PROJECT_STORY",P."PROJECT_AT_NM",P."PROJECT_AT_PF",P."PROJECT_AT_SNS1",P."PROJECT_AT_SNS2",P."PROJECT_AT_CONT",P."PROJECT_AT_EM",P."PROJECT_ER_DT",P."PROJECT_MF_DT",P."PROJECT_WRITER",P."PROJECT_CT_NO",P."PROJECT_ST_NO",P."PROJECT_COUNT",P."PROJECT_AT_INT", C.PROJECT_CT_NAME, FLOOR(PROJECT_CLOSE_DT - SYSDATE) AS D_DAY, NVL((SELECT SUM(TOTAL) FROM RESERVE_VIEW V WHERE V.RESERVE_REF_PNO = P.PROJECT_NO AND V.RESERVE_STATUS_NO IN (1,2,4) GROUP BY RESERVE_REF_PNO),0) AS TOTAL, (CASE WHEN PROJECT_CLOSE_DT < SYSDATE THEN NULL ELSE PROJECT_COUNT END) AS COUNTCOUNT, (SELECT COUNT(DISTINCT(HIS.RESERVE_NO)) FROM HISTORY HIS JOIN RESERVE RES ON ( HIS.RESERVE_NO = RES.RESERVE_NO ) WHERE RES.RESERVE_REF_PNO = P.PROJECT_NO ) AS SUPPORT_COUNT
FROM PROJECT_TB P
JOIN PROJECT_CG C ON ( P.PROJECT_CT_NO = C.PROJECT_CT_NO )
WHERE PROJECT_ST_NO IN ( 4, 5, 7 )
ORDER BY COUNTCOUNT DESC NULLS LAST;

  CREATE OR REPLACE FORCE VIEW PROJECT_DETAIL_VIEW ("PROJECT_NO", "PROJECT_TITLE", "PROJECT_STITLE", "PROJECT_GOAL", "PROJECT_THUMB_IMG", "PROJECT_START_DT", "PROJECT_CLOSE_DT", "PROJECT_HASHTAG", "PROJECT_MAIN_IMG", "PROJECT_SUMMARY", "PROJECT_STORY", "PROJECT_AT_NM", "PROJECT_AT_PF", "PROJECT_AT_SNS1", "PROJECT_AT_SNS2", "PROJECT_AT_CONT", "PROJECT_AT_EM", "PROJECT_ER_DT", "PROJECT_MF_DT", "PROJECT_WRITER", "PROJECT_CT_NO", "PROJECT_ST_NO", "PROJECT_COUNT", "D_DAY", "PROJECT_OPEN_COUNT", "TOTAL") AS 
  SELECT PT."PROJECT_NO",PT."PROJECT_TITLE",PT."PROJECT_STITLE",PT."PROJECT_GOAL",PT."PROJECT_THUMB_IMG",PT."PROJECT_START_DT",PT."PROJECT_CLOSE_DT",PT."PROJECT_HASHTAG",PT."PROJECT_MAIN_IMG",PT."PROJECT_SUMMARY",PT."PROJECT_STORY",PT."PROJECT_AT_NM",PT."PROJECT_AT_PF",PT."PROJECT_AT_SNS1",PT."PROJECT_AT_SNS2",PT."PROJECT_AT_CONT",PT."PROJECT_AT_EM",PT."PROJECT_ER_DT",PT."PROJECT_MF_DT",PT."PROJECT_WRITER",PT."PROJECT_CT_NO",PT."PROJECT_ST_NO",PT."PROJECT_COUNT", FLOOR(PROJECT_CLOSE_DT - SYSDATE) AS D_DAY, (SELECT COUNT(*) FROM PROJECT_TB P JOIN USER_TB U ON( U.USER_NO = P. PROJECT_WRITER) WHERE P. PROJECT_WRITER = PT.PROJECT_WRITER ) "PROJECT_OPEN_COUNT",
NVL((SELECT SUM(TOTAL) FROM RESERVE_VIEW V WHERE V.RESERVE_REF_PNO = PT.PROJECT_NO AND V.RESERVE_STATUS_NO IN (1,2,4) GROUP BY RESERVE_REF_PNO), 0) AS TOTAL
FROM PROJECT_TB PT
JOIN USER_TB U ON( U.USER_NO = PT. PROJECT_WRITER);

  CREATE OR REPLACE FORCE VIEW PROJECT_DETAIL_VIEW_2ND ("PROJECT_NO", "PROJECT_TITLE", "PROJECT_STITLE", "PROJECT_GOAL", "PROJECT_THUMB_IMG", "PROJECT_START_DT", "PROJECT_CLOSE_DT", "PROJECT_HASHTAG", "PROJECT_MAIN_IMG", "PROJECT_SUMMARY", "PROJECT_STORY", "PROJECT_AT_NM", "PROJECT_AT_PF", "PROJECT_AT_SNS1", "PROJECT_AT_SNS2", "PROJECT_AT_CONT", "PROJECT_AT_EM", "PROJECT_ER_DT", "PROJECT_MF_DT", "PROJECT_WRITER", "PROJECT_CT_NO", "PROJECT_ST_NO", "PROJECT_COUNT", "D_DAY", "PROJECT_OPEN_COUNT", "TOTAL", "PROJECT_CT_NAME", "USERCOUNT") AS 
  SELECT PT."PROJECT_NO",PT."PROJECT_TITLE",PT."PROJECT_STITLE",PT."PROJECT_GOAL",PT."PROJECT_THUMB_IMG",PT."PROJECT_START_DT",PT."PROJECT_CLOSE_DT",PT."PROJECT_HASHTAG",PT."PROJECT_MAIN_IMG",PT."PROJECT_SUMMARY",PT."PROJECT_STORY",PT."PROJECT_AT_NM",PT."PROJECT_AT_PF",PT."PROJECT_AT_SNS1",PT."PROJECT_AT_SNS2",PT."PROJECT_AT_CONT",PT."PROJECT_AT_EM",PT."PROJECT_ER_DT",PT."PROJECT_MF_DT",PT."PROJECT_WRITER",PT."PROJECT_CT_NO",PT."PROJECT_ST_NO",PT."PROJECT_COUNT", FLOOR(PROJECT_CLOSE_DT - SYSDATE) AS D_DAY, (SELECT COUNT(*) FROM PROJECT_TB P JOIN USER_TB U ON( U.USER_NO = P. PROJECT_WRITER) WHERE P. PROJECT_WRITER = PT.PROJECT_WRITER ) "PROJECT_OPEN_COUNT",
NVL((SELECT SUM(TOTAL) FROM RESERVE_VIEW V WHERE V.RESERVE_REF_PNO = PT.PROJECT_NO AND V.RESERVE_STATUS_NO IN (1,2,4) GROUP BY RESERVE_REF_PNO), 0) AS TOTAL, cg.project_ct_name,
NVL((SELECT COUNT(RESERVE_REF_PNO) 
FROM RESERVE
WHERE RESERVE_STATUS_NO IN('1', '2') AND RESERVE_REF_PNO = PT."PROJECT_NO"
GROUP BY RESERVE_REF_PNO),0) AS USERCOUNT


FROM PROJECT_TB PT
JOIN USER_TB U ON( U.USER_NO = PT. PROJECT_WRITER)
JOIN PROJECT_CG CG ON ( PT.PROJECT_CT_NO = CG.PROJECT_CT_NO);

CREATE OR REPLACE VIEW PROJECT_LIST_VIEW_2ND AS
SELECT b.*, (CASE WHEN PROJECT_CLOSE_DT < SYSDATE THEN NULL ELSE PROJECT_START_DT END ) AS RECENT, (CASE WHEN PROJECT_CLOSE_DT < SYSDATE THEN NULL ELSE TOTAL END ) AS AMOUNT, (CASE WHEN PROJECT_CLOSE_DT < SYSDATE THEN NULL ELSE PROJECT_CLOSE_DT END ) AS CLOSING, (CASE WHEN PROJECT_CLOSE_DT < SYSDATE THEN NULL ELSE SUPPORT_COUNT END ) AS SUPPORT
FROM PROJECT_LIST_VIEW b ;

SELECT P.*, (CASE WHEN PROJECT_NO IN (SELECT LIKE_PRJ FROM LIKE_TB WHERE LIKE_USER = 28) THEN 1 ELSE 0 END) AS ILIKE
FROM PROJECT_LIST_VIEW P
ORDER BY COUNTCOUNT DESC NULLS LAST;

SELECT P.*, (CASE WHEN PROJECT_NO IN (SELECT LIKE_PRJ FROM LIKE_TB WHERE LIKE_USER = 28) THEN 1 ELSE 0 END) AS ILIKE
FROM PROJECT_LIST_VIEW_2ND P
ORDER BY CLOSING ASC NULLS LAST;

SELECT COUNT(DISTINCT(HIS.RESERVE_NO)) FROM HISTORY HIS
JOIN RESERVE RES ON ( HIS.RESERVE_NO = RES.RESERVE_NO )
WHERE RES.RESERVE_REF_PNO = 54

;

SELECT LIKE_PRJ FROM LIKE_TB
WHERE LIKE_USER = 28;

SELECT P.*, C.PROJECT_CT_NAME, FLOOR(PROJECT_CLOSE_DT - SYSDATE) AS D_DAY, NVL((SELECT SUM(TOTAL) FROM RESERVE_VIEW V WHERE V.RESERVE_REF_PNO = P.PROJECT_NO GROUP BY RESERVE_REF_PNO),0) AS TOTAL, (CASE WHEN PROJECT_NO IN (SELECT LIKE_PRJ FROM LIKE_TB WHERE LIKE_USER = 28) THEN 1 ELSE 0 END ) AS USER_LIKE
FROM PROJECT_TB P
JOIN PROJECT_CG C ON ( P.PROJECT_CT_NO = C.PROJECT_CT_NO )
WHERE PROJECT_ST_NO IN ( 4, 5 )
ORDER BY PROJECT_COUNT DESC, PROJECT_CLOSE_DT DESC;

SELECT * FROM PROJECT_LIST_VIEW
WHERE PROJECT_NO = 54;

CREATE OR REPLACE VIEW HIS_RWD_VIEW AS
SELECT * FROM HISTORY
JOIN REWARD USING ( REWARD_NO );

---------- HISTORY 테이블 INSERT 시 REWARD 테이블의 AMOUNT 재고를 감소시키는 트리거
CREATE OR REPLACE TRIGGER TRG_HIS_INSERT
AFTER INSERT
ON HISTORY
FOR EACH ROW
BEGIN
    UPDATE REWARD
    SET REWARD_AMOUNT = REWARD_AMOUNT - :NEW.REWARD_SUM
    WHERE REWARD_NO = :NEW.REWARD_NO;
END;
/

-------- HISTORY 테이블 UPDATE 시? 아님 DELETE 시? 테이블의 AMOUNT 재고를 증가시키는 트리거
----- 앗 아니다 RESERVE 테이블 RESERVE_STATUS 를 취소로 UPDATE 시 AMOUNT 재고를 증가시키자
SELECT * FROM REWARD
WHERE REWARD_NO IN (
SELECT REWARD_NO FROM HISTORY
JOIN RESERVE USING ( RESERVE_NO )
WHERE RESERVE_NO = 1);


SET SERVEROUTPUT ON;
--- 헐 설마 한번에 동작하면 떨려서 어쩌지 ;ㅁ;
-- 안된당 ㅠㅠㅠ 흑흑 변수 선언하는걸로 어케어케 해봐야지
-- 아 지금 웨어절이 여러개가 나오는데 그중에 + 할떄 연동할 REWARD_NO를 선택을 못하는구나 IF문 안에서 FOR문을 돌려봐야지
--- 얼 대박 된다 ㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠ
--- 됩니다 ㅠㅠㅠㅠㅠㅠ 되여
CREATE OR REPLACE TRIGGER TRG_RSV_UPDATE
AFTER UPDATE
ON RESERVE
FOR EACH ROW
DECLARE
    V_RWD_NO HISTORY.REWARD_NO%TYPE;
    V_RWD_SUM HISTORY.REWARD_SUM%TYPE;
    V_COUNT NUMBER;
    
    -- 커서 생성 선언
    CURSOR C1
    IS SELECT H.REWARD_NO, H.REWARD_SUM 
        FROM HISTORY H
        WHERE RESERVE_NO = :NEW.RESERVE_NO;
BEGIN
    SELECT COUNT(*)
    INTO V_COUNT
    FROM HISTORY
    WHERE RESERVE_NO = :NEW.RESERVE_NO;
    
    DBMS_OUTPUT.PUT_LINE('트리거 실행');
    DBMS_OUTPUT.PUT_LINE(:NEW.RESERVE_NO);
    
    IF :NEW.RESERVE_STATUS_NO = 3
    THEN
        DBMS_OUTPUT.PUT_LINE('더하기 동작 실행');
        OPEN C1; -- 커서 오픈
        
        LOOP
            FETCH C1 --커서 패치 : 서브쿼리의 결과에서 한 ROW씩 순서대로 데이터를 가져옴
            INTO V_RWD_NO, V_RWD_SUM;
            DBMS_OUTPUT.PUT_LINE(C1%ROWCOUNT);
            UPDATE REWARD
            SET REWARD_AMOUNT = REWARD_AMOUNT + V_RWD_SUM
            WHERE REWARD_NO = V_RWD_NO;
            DBMS_OUTPUT.PUT_LINE(V_RWD_NO||'번 리워드 의 갯수 '||V_RWD_SUM);
            EXIT WHEN V_COUNT = C1%ROWCOUNT;
        END LOOP;
        CLOSE C1;
       
    END IF;

END;
/

DROP TRIGGER TRG_TOTAL_CANCELRESERVE;
CREATE OR REPLACE TRIGGER TRG_TOTAL_CANCELRESERVE
AFTER UPDATE ON RESERVE
FOR EACH ROW
DECLARE
    V_PROJECT_NO NUMBER;
    V_REWARDPRICE NUMBER;
    V_ADDI NUMBER;
    V_RESERVE_NO NUMBER;
    V_RESERVE_STATUS_NO NUMBER;
BEGIN
    V_RESERVE_STATUS_NO := :NEW.RESERVE_STATUS_NO;
    IF V_RESERVE_STATUS_NO = 3
    THEN
        V_RESERVE_NO := :NEW.RESERVE_NO;
        V_PROJECT_NO := :NEW.RESERVE_REF_PNO;
        SELECT SUM(REWARD_PRICE * REWARD_SUM) INTO V_REWARDPRICE FROM HISTORY JOIN REWARD USING(REWARD_NO) WHERE RESERVE_NO = V_RESERVE_NO;
        SELECT ADDITIONAL INTO V_ADDI FROM RESERVE WHERE RESERVE_NO = V_RESERVE_NO;
        UPDATE PROJECT_TB SET PROJECT_TOTAL = PROJECT_TOTAL - (V_REWARDPRICE + V_ADDI) WHERE PROJECT_NO = V_PROJECT_NO;
    END IF;
END;
/

--- UPDATE TRG 테스트용 
UPDATE RESERVE
SET RESERVE_STATUS_NO = 3
WHERE RESERVE_NO = 2;

SELECT H.REWARD_NO, H.REWARD_SUM 
        FROM HISTORY H
        WHERE RESERVE_NO = 2;

ROLLBACK;
COMMIT;
SELECT REWARD_NO, REWARD_SUM FROM HISTORY
        WHERE RESERVE_NO = 3;

SELECT COUNT(*) FROM HISTORY WHERE RESERVE_NO = 1;


--- 해당프로젝트에 해당 유저가 펀딩한 기록 가져오기
SELECT * FROM RESERVE WHERE RESERVE_REF_PNO = 54 AND RESERVE_USER = 25;

--- 특정 RESERVE_NO로 예약된 REWARD 목록 가져오기
SELECT * FROM HISTORY WHERE RESERVE_NO = 2;

-- 프로젝트 제목, USER 닉네임 포함한 VIEW 생성
CREATE OR REPLACE VIEW RESERVE_VIEW_2ND AS
SELECT R.*, P.PROJECT_TITLE, U.USER_NICKNAME, (SELECT SUM( REWARD_PRICE ) FROM HISTORY H JOIN REWARD RW ON ( H.REWARD_NO = RW.REWARD_NO ) WHERE H.RESERVE_NO = R.RESERVE_NO GROUP BY RESERVE_NO) AS "REWARD_PRICE_SUM", P.PROJECT_CLOSE_DT+1 AS "FUND_DATE"
FROM RESERVE R
JOIN PROJECT_TB P ON ( R.RESERVE_REF_PNO = P.PROJECT_NO )
JOIN USER_TB U ON ( R.RESERVE_USER = U.USER_NO )
;

SELECT SUM( REWARD_PRICE ) FROM HISTORY H JOIN REWARD RW ON ( H.REWARD_NO = RW.REWARD_NO ) WHERE H.RESERVE_NO = 2 GROUP BY RESERVE_NO
;

SELECT *
FROM RESERVE_VIEW_2nd
WHERE RESERVE_NO = 2;

SELECT * FROM HISTORY 
JOIN REWARD USING( REWARD_NO )
WHERE RESERVE_NO = 2;

SELECT PROJECT_CLOSE_DT+1 FROM PROJECT_TB;

-- 예약 시퀀스 호출 테스트
SELECT SEQ_RES_NO.CURRVAL
		FROM DUAL;

--- 특정 유저가 예약한 내역 조회
CREATE OR REPLACE VIEW RESERVE_USER_VIEW AS
SELECT R.RESERVE_NO, R.RESERVE_DATE, R.RESERVE_USER, R.RESERVE_REF_PNO, R.RESERVE_STATUS_NO, R.PROJECT_TITLE, R.FUND_DATE, P.PROJECT_AT_NM, P.PROJECT_CT_NAME, P.D_DAY, P.PROJECT_ST_NO
FROM RESERVE_VIEW_2ND R
JOIN PROJECT_LIST_VIEW_2ND P ON ( R.RESERVE_REF_PNO = P.PROJECT_NO )
ORDER BY R.RESERVE_DATE DESC;
		WHERE RESERVE_USER = 17;
        
SELECT * FROM RESERVE_USER_VIEW
WHERE RESERVE_USER = 17;

CREATE OR REPLACE TRIGGER TRG_REPORT_ALARM
AFTER INSERT
ON REPORT_TB
FOR EACH ROW

BEGIN
    INSERT INTO ALARM VALUES ( SEQ_ALA_NO.NEXTVAL, '신고', '신고가 접수 되었습니다', DEFAULT, SYSDATE, :NEW.REPORT_REF_PNO);
END;
/



CREATE SEQUENCE SEQ_ALA_NO NOCACHE;

CREATE OR REPLACE TRIGGER TRG_100_ALARM
AFTER INSERT 
ON RESERVE
FOR EACH ROW
DECLARE 
    V_REFPNO NUMBER ;
    V_PGOAL NUMBER;
    V_CURRENT NUMBER;
BEGIN
    V_REFPNO := :NEW.RESERVE_REF_PNO;
    SELECT PROJECT_GOAL INTO V_PGOAL FROM PROJECT_TB WHERE PROJECT_NO = V_REFPNO;
    SELECT TOTAL INTO V_CURRENT FROM PROJECT_LIST_VIEW WHERE PROJECT_NO = V_REFPNO;

    IF V_PGOAL <= V_CURRENT 
    THEN
        INSERT INTO ALARM VALUES ( SEQ_ALA_NO.NEXTVAL, '펀딩성공', V_REFPNO ||'번 프로젝트가 달성률 100% 성공 하였습니다', DEFAULT, SYSDATE, V_REFPNO);
    END IF;
END;
/

DROP TRIGGER TRG_100_ALARM;

COMMIT;
SELECT TOTAL FROM PROJECT_LIST_VIEW WHERE PROJECT_NO = 54;

CREATE OR REPLACE FORCE VIEW PROJECT_LIST_VIEW_3RD AS 
SELECT P."PROJECT_NO",P."PROJECT_TITLE",P."PROJECT_STITLE",P."PROJECT_GOAL",P."PROJECT_THUMB_IMG",P."PROJECT_START_DT",P."PROJECT_CLOSE_DT",P."PROJECT_HASHTAG",P."PROJECT_MAIN_IMG",P."PROJECT_SUMMARY",P."PROJECT_STORY",P."PROJECT_AT_NM",P."PROJECT_AT_PF",P."PROJECT_AT_SNS1",P."PROJECT_AT_SNS2",P."PROJECT_AT_CONT",P."PROJECT_AT_EM",P."PROJECT_ER_DT",P."PROJECT_MF_DT",P."PROJECT_WRITER",P."PROJECT_CT_NO",P."PROJECT_ST_NO",P."PROJECT_COUNT",P."PROJECT_AT_INT", C.PROJECT_CT_NAME, FLOOR(PROJECT_CLOSE_DT - SYSDATE) AS D_DAY, NVL((SELECT SUM(TOTAL) FROM RESERVE_VIEW V WHERE V.RESERVE_REF_PNO = P.PROJECT_NO AND V.RESERVE_STATUS_NO IN ( 1, 2, 4) GROUP BY RESERVE_REF_PNO),0) AS TOTAL, (CASE WHEN PROJECT_CLOSE_DT < SYSDATE THEN NULL ELSE PROJECT_COUNT END) AS COUNTCOUNT, (SELECT COUNT(DISTINCT(HIS.RESERVE_NO)) FROM HISTORY HIS JOIN RESERVE RES ON ( HIS.RESERVE_NO = RES.RESERVE_NO ) WHERE RES.RESERVE_REF_PNO = P.PROJECT_NO ) AS SUPPORT_COUNT, NVL((SELECT SUM(ADDITIONAL) FROM RESERVE WHERE RESERVE_REF_PNO = P.PROJECT_NO AND RESERVE_STATUS_NO IN ( 1, 2, 4)),0) AS "ADDITIONAL" 
FROM PROJECT_TB P
JOIN PROJECT_CG C ON ( P.PROJECT_CT_NO = C.PROJECT_CT_NO )
WHERE PROJECT_ST_NO IN ( 4, 5, 7 )
ORDER BY COUNTCOUNT DESC NULLS LAST;

SELECT * FROM PROJECT_LIST_VIEW_3RD;