class APIPath{
  static String job(String uid,String jobId)=> 'users/$uid/jobs/$jobId';
  static String jobs(String uid) => 'users/$uid/jobs';
  //  User collection
  static String user(String documentId)=> 'users/$documentId';
  static String users() => 'users';
  // grades collection
  static String grades() => 'grades';
  static String grade(String documentId)=> 'grades/$documentId';

  //subject collection
  static String subject(String documentId)=>'subjects/$documentId';
  static String subjects()=>'subjects';
}