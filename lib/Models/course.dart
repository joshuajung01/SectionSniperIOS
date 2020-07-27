class Course {
  String dept;
  String num;
  String sec;

  Course(String d, String n, String s){
    this.dept = d;
    this.num = n;
    this.sec = s;
  }

  String getDept() => dept;
  String getNum() => num;
  String getSec() => sec;

  void setDept(String d) {dept = d;}
  void setNum(String n) {num = n;}
  void setSec(String s) {sec = s;}

  @override
  String toString() => '$dept $num $sec';
}