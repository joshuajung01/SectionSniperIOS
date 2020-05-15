class detailedCourse {
  String dept;
  String num;
  String sec;
  int open;
  String crn;

  detailedCourse(String d, String n, String s, int o, String c,){
    this.dept = d;
    this.num = n;
    this.sec = s;
    this.open = o;
    this.crn = c;
  }


  @override
  String toString() => '$dept $num $sec';
}