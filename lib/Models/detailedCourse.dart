class DetailedCourse {
  String dept;
  String num;
  String sec;
  int open;
  String crn;
  String title;
  String profName;
  int maxCap;
  bool selected;


  DetailedCourse(String d, String n, String s, int o, String c, String t, String pn, int mc, bool select){
    this.dept = d;
    this.num = n;
    this.sec = s;
    this.open = o;
    this.crn = c;
    this.title = t;
    this.profName = pn;
    this.maxCap = mc;
    this.selected = select;
  }

  void reverseSelected(){
    this.selected = !this.selected;
  }

  @override
  String toString() => '$dept $num $sec';
}