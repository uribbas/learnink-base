class APIPath{
  static String job(String uid,String jobId)=> 'users/$uid/jobs/$jobId';
  static String jobs(String uid) => 'users/$uid/jobs';
  //  User collection
  static String user(String documentId)=> 'users/$documentId';
  static String users() => 'users';
}