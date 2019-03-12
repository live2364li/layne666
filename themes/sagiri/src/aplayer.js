const apFixed = new APlayer({
  element: document.getElementById('aplayer-fixed'),
  mutex: true,
  theme: '#97dffd',
  order: 'random',
  lrcType: 3,
  fixed: true,
});
$.ajax({
  type:"GET",
  url: 'http://api.layne666.site/api?type=list&id=2652030925',
  dataType:"jsonp",  //数据格式设置为jsonp
  jsonp:"callback", 
  success: function (list) {
    apFixed.list.add(JSON.parse(list));
  }
});
