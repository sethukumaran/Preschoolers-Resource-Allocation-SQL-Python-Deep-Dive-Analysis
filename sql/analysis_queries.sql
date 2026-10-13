
-- 01. Dataset profile
SELECT COUNT(*) AS children,
       COUNT(DISTINCT ID) AS unique_children,
       ROUND(AVG(age),2) AS avg_age,
       MIN(age) AS min_age,
       MAX(age) AS max_age
FROM preschoolers;

-- 02. Gender distribution
SELECT Gender, COUNT(*) AS children,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM preschoolers),2) AS pct
FROM preschoolers
GROUP BY Gender
ORDER BY children DESC;

-- 03. Overall score summary
SELECT ROUND(AVG(GS),3) AS avg_GS,
       ROUND(AVG(AGS_one_token),3) AS avg_AGS_one_token,
       ROUND(AVG(AGS_two_token),3) AS avg_AGS_two_token,
       ROUND(AVG(AGS_three_token),3) AS avg_AGS_three_token,
       ROUND(AVG(LS),3) AS avg_LS,
       ROUND(AVG(ES),3) AS avg_ES
FROM preschoolers;

-- 04. Outcomes by gender
SELECT Gender, COUNT(*) AS children,
       ROUND(AVG(age),2) AS avg_age,
       ROUND(AVG(GS),3) AS avg_GS,
       ROUND(AVG(AGS_one_token),3) AS avg_AGS_one_token,
       ROUND(AVG(AGS_two_token),3) AS avg_AGS_two_token,
       ROUND(AVG(AGS_three_token),3) AS avg_AGS_three_token,
       ROUND(AVG(LS),3) AS avg_LS,
       ROUND(AVG(ES),3) AS avg_ES
FROM preschoolers
GROUP BY Gender
ORDER BY Gender;

-- 05. Global-task order effects
SELECT order_DT, COUNT(*) AS children,
       ROUND(AVG(GS),3) AS avg_GS,
       ROUND(AVG(AGS_one_token),3) AS avg_AGS_one_token,
       ROUND(AVG(AGS_two_token),3) AS avg_AGS_two_token,
       ROUND(AVG(AGS_three_token),3) AS avg_AGS_three_token
FROM preschoolers
GROUP BY order_DT
ORDER BY order_DT;

-- 06. Language-task order effects
SELECT Order_LT, COUNT(*) AS children,
       ROUND(AVG(LS),3) AS avg_LS,
       ROUND(AVG(GS),3) AS avg_GS
FROM preschoolers
GROUP BY Order_LT
ORDER BY Order_LT;

-- 07. Executive-task order effects
SELECT Order_ET, COUNT(*) AS children,
       ROUND(AVG(ES),3) AS avg_ES,
       ROUND(AVG(GS),3) AS avg_GS
FROM preschoolers
GROUP BY Order_ET
ORDER BY Order_ET;

-- 08. Highest GS observations
SELECT ID, Gender, age, GS, LS, ES,
       AGS_one_token, AGS_two_token, AGS_three_token
FROM preschoolers
ORDER BY GS DESC, ID
LIMIT 10;

-- 09. Lowest GS observations
SELECT ID, Gender, age, GS, LS, ES,
       AGS_one_token, AGS_two_token, AGS_three_token
FROM preschoolers
ORDER BY GS ASC, ID
LIMIT 10;

-- 10. Resource/task component utilization
SELECT
    SUM(OneB1) AS OneB1, SUM(OneU1) AS OneU1, SUM(Onecup1) AS Onecup1,
    SUM(OneB2) AS OneB2, SUM(OneU2) AS OneU2, SUM(Onecup2) AS Onecup2,
    SUM(TwoB1) AS TwoB1, SUM(TwoU1) AS TwoU1, SUM(Twocup1) AS Twocup1,
    SUM(TwoB2) AS TwoB2, SUM(TwoU2) AS TwoU2, SUM(Twocup2) AS Twocup2,
    SUM(ThreeB1) AS ThreeB1, SUM(ThreeU1) AS ThreeU1, SUM(Threecup1) AS Threecup1,
    SUM(ThreeB2) AS ThreeB2, SUM(ThreeU2) AS ThreeU2, SUM(Threecup2) AS Threecup2
FROM preschoolers;
