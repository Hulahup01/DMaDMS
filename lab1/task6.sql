CREATE OR REPLACE FUNCTION CalculateTotalCompensation(p_monthly_salary NUMBER, p_annual_bonus_percentage NUMBER) RETURN NUMBER IS
  v_annual_bonus_fraction NUMBER := p_annual_bonus_percentage / 100.0;
  v_total_compensation NUMBER;
BEGIN
  IF p_monthly_salary <= 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Значение месячной зарплаты должно быть положительным числом.');
  ELSIF p_annual_bonus_percentage < 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'Процент годовых премиальных не может быть отрицательным.');
  ELSE
    v_total_compensation := (1 + v_annual_bonus_fraction) * 12 * p_monthly_salary;
    RETURN v_total_compensation;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20003, 'Произошла ошибка: ' || SQLERRM);
END;


DECLARE
  v_total_compensation NUMBER;
BEGIN
  v_total_compensation := CalculateTotalCompensation(5000, 10);
  DBMS_OUTPUT.PUT_LINE('Общее вознаграждение за год: ' || v_total_compensation);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Произошла ошибка: ' || SQLERRM);
END;
