package vo;

public class Salary {
	// public int empNo; // 1번방법 직접 join결과물 못받음
	public Employee emp; // 2번방법 직접 join결과물 받음 salary객체를 받으려면 emp객체를 하나씩 만들어야한다 inner join결과물을 저장하기 위해서 쓴다.
	public int salary;
	public String fromDate;
	public String toDate;
	
	/*
	public static void main(String[] args) {
		Salary s = new Salary();
		s.emp = new Employee(); // 이걸 안쓰면 밑에 s.emp.empNo도 못씀
		s.emp.empNo = 1;
		s.salary = 5000;
		s.fromDate = "2021-01-01";
		s.totDate = "2021-12-31";
	}
	*/
}


