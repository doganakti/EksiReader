class Pager {
  int pageCount;
  int page;
  String quickIndexPath;
  String quickIndexText;
  
  Pager({this.pageCount, this.page, this.quickIndexPath, this.quickIndexText})
  {
    pageCount = pageCount == null ? 1 : pageCount;
    page = page == null ? 1 : page;
  }
}
