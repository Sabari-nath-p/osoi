weekdaytoInt(String week) {
  int val = 0;
  if (week == "Sunday") val = 0;
  if (week == "Monday") val = 1;
  if (week == "Tuesday") val = 2;
  if (week == "Wednesday") val = 3;
  if (week == "Thrusday") val = 4;
  if (week == "Firday") val = 5;
  if (week == "Saturday") val = 6;
  return val;
}

weeksort(List sort) {
  for (int i = 0; i < sort.length; i++) {
    for (int j = 0; j < sort.length - 1; j++) {
      if (sort[j] > sort[j + 1]) {
        int temp = sort[j];
        sort[j] = sort[j + 1];
        sort[j + 1] = temp;
      }
    }
  }
  return sort;
}

DateTime initalDatefinder(List sort) {
  int key = -1;
  DateTime initalDatetime = DateTime.now().add(Duration(days: 7));
  int cdate = DateTime.now().add(Duration(days: 7)).weekday;
  for (var im in sort) {
    if ((cdate - im) <= 0) {
      key = 1;
      initalDatetime = initalDatetime.add(Duration(days: im - cdate));
      break;
    }
  }
  if (key == -1)
    initalDatetime =
        initalDatetime.add(Duration(days: (cdate - sort[0]).toInt()));

  return (initalDatetime);
}
