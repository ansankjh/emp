package vo;

public class DeptEmp {
	// 테이블 컬럼과 일치하는것만 입력한 도메인타입
	// 단점 : 이 도메인 타입으로는 JOIN 결과를 처리할수 없다 그래서 안쓴다. JOIN결과를 vo타입으로 못받는다.
	// public int emp_no;
	// public int dept_no;
	
	// 장점 : dept_emp테이블의 행뿐만아니라 JOIN결과의 행도 처리할 수 있다.
	// 단점 : 복잡하다.
	public Employee emp;
	public Department dept;
	public String fromDate;
	public String toDate;
}
