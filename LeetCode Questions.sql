-- LeetCode SQL Problems with Solutions

-- 1. #176. Second Highest Salary
SELECT (
  SELECT DISTINCT salary
  FROM Employee
  ORDER BY salary DESC
  LIMIT 1 OFFSET 1
) AS SecondHighestSalary;

-- 2. #183. Customers Who Never Order
SELECT c.name AS Customers
FROM Customers c
LEFT JOIN Orders o ON c.id = o.customerId
WHERE o.id IS NULL;

-- 3. #184. Department Highest Salary
WITH DeptMax AS (
  SELECT departmentId, MAX(salary) AS max_salary
  FROM Employee
  GROUP BY departmentId
)
SELECT d.name AS Department,
       e.name AS Employee,
       e.salary AS Salary
FROM DeptMax dm
JOIN Employee e ON e.departmentId = dm.departmentId AND e.salary = dm.max_salary
JOIN Department d ON d.id = dm.departmentId;

-- 4. #196. Delete Duplicate Emails
DELETE p1
FROM Person p1, Person p2
WHERE p1.email = p2.email AND p1.id > p2.id;

-- 5. #197. Rising Temperature
SELECT w1.id
FROM Weather w1
JOIN Weather w2 ON DATEDIFF(w1.recordDate, w2.recordDate) = 1
WHERE w1.temperature > w2.temperature;

-- 6. #595. Big Countries
SELECT name, population, area
FROM World
WHERE area >= 3000000 OR population >= 25000000;

-- 7. #177. Nth Highest Salary
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
    SELECT DISTINCT salary
    FROM Employee
    ORDER BY salary DESC
    LIMIT 1 OFFSET N - 1
  );
END

-- 8. #178. Rank Scores
SELECT score,
       DENSE_RANK() OVER (ORDER BY score DESC) AS 'rank'
FROM Scores;

-- 9. #180. Consecutive Numbers
SELECT DISTINCT l1.num AS ConsecutiveNums
FROM Logs l1
JOIN Logs l2 ON l2.id = l1.id + 1 AND l2.num = l1.num
JOIN Logs l3 ON l3.id = l1.id + 2 AND l3.num = l1.num;

-- 10. #181. Employees Earning More Than Their Managers
SELECT e.name AS Employee
FROM Employee e
JOIN Employee m ON e.managerId = m.id
WHERE e.salary > m.salary;

-- 11. #182. Duplicate Emails
SELECT email
FROM Person
GROUP BY email
HAVING COUNT(*) > 1;

-- 12. #511. Game Play Analysis I
SELECT player_id, MIN(event_date) AS first_login
FROM Activity
GROUP BY player_id;

-- 13. #512. Game Play Analysis II
SELECT player_id, device_id
FROM Activity
WHERE (player_id, event_date) IN (
  SELECT player_id, MIN(event_date)
  FROM Activity
  GROUP BY player_id
);

-- 14. #534. Game Play Analysis III
SELECT player_id,
       event_date,
       SUM(games_played) OVER (PARTITION BY player_id ORDER BY event_date) AS games_played_so_far
FROM Activity;

-- 15. #570. Managers with at Least 5 Direct Reports
SELECT name
FROM Employee
WHERE id IN (
  SELECT managerId
  FROM Employee
  GROUP BY managerId
  HAVING COUNT(*) >= 5
);

-- 16. #584. Find Customer Referee
SELECT name
FROM Customer
WHERE referee_id != 2 OR referee_id IS NULL;

-- 17. #586. Customer Placing the Largest Number of Orders
SELECT customer_number
FROM Orders
GROUP BY customer_number
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 18. #607. Sales Person
SELECT name
FROM SalesPerson
WHERE sales_id NOT IN (
  SELECT o.sales_id
  FROM Orders o
  JOIN Company c ON o.com_id = c.com_id
  WHERE c.name = 'RED'
);

-- 19. #1141. User Activity for the Past 30 Days I
SELECT DISTINCT activity_date AS day,
       COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN DATE_SUB('2019-07-27', INTERVAL 29 DAY) AND '2019-07-27'
GROUP BY activity_date;

-- 20. #1280. Students and Examinations
SELECT s.student_id, s.student_name, su.subject_name, 
       COUNT(e.subject_name) AS attended_exams
FROM Students s
CROSS JOIN Subjects su
LEFT JOIN Examinations e ON s.student_id = e.student_id AND su.subject_name = e.subject_name
GROUP BY s.student_id, su.subject_name
ORDER BY s.student_id, su.subject_name;
