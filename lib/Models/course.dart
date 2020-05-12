class Course {
  String dept;
  int num;
  int sec;

  Course(String d, int n, int s){
    this.dept = d;
    this.num = n;
    this.sec = s;
  }

  String getDept() => dept;
  int getNum() => num;
  int getSec() => sec;

  void setDept(String d) {dept = d;}
  void setNum(int n) {num = n;}
  void setSec(int s) {sec = s;}

  @override
  String toString() => '$dept $num $sec';
}