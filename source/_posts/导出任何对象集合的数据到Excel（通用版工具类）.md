---
title: 导出任何对象集合的数据到Excel（通用版工具类）
copyright_author_href: https://layne666.cn
cover: https://pan.layne666.cn/images/2021/12/02/F4ArtVrus6.png
date: 2019-03-07 01:51:19
updated: 2019-03-07 01:57:28
categories: 
  - Java
tags: 
  - Java
  - Excel
  - 反射
---

该工具类可以导出任何对象集合的数据到Excel（`对象必须已有getter方法`），但**对象属性个数、顺序要和列标题保持一致**。

废话不多说，直接上源码以及测试代码，有误或者有不理解的地方，还望一起讨论！

## 工具类源码

```java
/**
 *  该工具类可以导出任何对象集合的数据到Excel（对象必须已有getter方法）
 *  但对象属性个数、顺序要和列标题保持一致
 *  如：String[] colTitles = {"姓名","年龄","地址"};
 *      String[] properties = {"name","age","address"};
 * @author Layne666
 */
public class ExcelUtils {
    /**
     *  导出数据到Excel，并进行下载
     * @param list       需要导出的对象集合
     * @param colTitles  列标题（各列的小标题）
     * @param properties 需要从对象中取出的属性
     * @param headTitle  头标题（中间的大标题）
     * @param fileName   导出时的下载文件名称
     * @param resp       响应输出流
     * @return           返回导出状态信息
     */
    public static Map<String,Object> exportExcel(List<Object> list, String[] colTitles, String[] properties, String headTitle, String fileName, HttpServletResponse resp) {
        Map<String, Object> result = new HashMap<>();
        //如果标题和对象属性个数不一致，则不继续进行导出
        if(colTitles.length != properties.length){
            result.put("msg","标题和对象属性个数不一致，无法匹配进行导出");
            result.put("success",false);
            return result;
        }
        //1.创建一个excel文件
        HSSFWorkbook workbook = new HSSFWorkbook();
        //1.1 创建合并单元格对象
        //起始行,结束行,起始列,结束列
        CellRangeAddress callRangeAddress = new CellRangeAddress(0,0,0,colTitles.length-1);
        //1.2 创建头标题样式
        HSSFCellStyle headStyle = createCellStyle(workbook,(short)16,true);
        //1.3 创建列标题样式
        HSSFCellStyle colStyle = createCellStyle(workbook,(short)13,true);
        //1.4 创建正文样式
        HSSFCellStyle valueStyle = createCellStyle(workbook,(short)10,false);

        //2.创建工作簿
        HSSFSheet sheet = workbook.createSheet();
        //2.1 加载合并单元格对象
        sheet.addMergedRegion(callRangeAddress);
        //2.2 设置默认列宽
        sheet.setDefaultColumnWidth(25);

        //3.创建行
        //3.1 创建头标题行;并且设置头标题
        HSSFRow row1 = sheet.createRow(0);
        //3.2 创建单元格
        HSSFCell cell = row1.createCell(0);
        //3.3 设置单元格样式
        cell.setCellStyle(headStyle);
        //3.4 设置单元格值
        cell.setCellValue(headTitle);

        //4.创建行
        //4.1 创建列标题行;并且设置列标题
        HSSFRow row2 = sheet.createRow(1);
        for (int i = 0;i < colTitles.length; i++){
            //4.2 创建单元格
            HSSFCell cell2 = row2.createCell(i);
            //4.3 设置单元格样式
            cell2.setCellStyle(colStyle);
            //4.4 设置单元格值
            cell2.setCellValue(colTitles[i]);
        }

        //5.操作单元格;将用户列表写入excel
        if(list != null) {
            for(int j=0;j<list.size();j++) {
                //5.1 创建数据行,前面有两行,头标题行和列标题行
                HSSFRow row3 = sheet.createRow(j + 2);
                //5.2 对属性数组进行遍历
                for (int k = 0;k < properties.length; k++) {
                    //5.3 创建单元格
                    HSSFCell cell3 = row3.createCell(k);
                    //5.4 设置单元格样式
                    cell3.setCellStyle(valueStyle);
                    //5.5 根据属性来获取对应的值，并设置到单元格中
                    cell3.setCellValue(String.valueOf(getGetMethod(list.get(j), properties[k])));
                }
            }
        }

        //5.获取输出流对象
        ServletOutputStream out = null;
        try {
            out = resp.getOutputStream();
            //6.添加时间，防止文件名字重复
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss");
            String timer = sdf.format(new Date(System.currentTimeMillis()));
            //7.设置信息头
            resp.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(fileName+"("+timer+")","UTF-8")+".xls");
            resp.setHeader("Content-Type", "application/octet-stream");
            //8.写出文件
            workbook.write(out);
            //9.返回信息
            result.put("msg","Excel导出成功");
            result.put("success",true);
        } catch (Exception e) {
            result.put("msg","Excel导出失败");
            result.put("success",false);
            e.printStackTrace();
        } finally {
            if(out != null){
                try {
                    //10.关闭输出流
                    out.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return result;
    }

    /**
     * 设置字体样式
     * @param workbook  excel文件
     * @param fontsize  字体大小
     * @param isBold    字体是否需要加粗
     * @return 样式
     */
    private static HSSFCellStyle createCellStyle(HSSFWorkbook workbook, short fontsize, Boolean isBold) {
        HSSFCellStyle style = workbook.createCellStyle();
        //水平居中
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        //垂直居中
        style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
        //创建字体
        HSSFFont font = workbook.createFont();
        //字体是否需要加粗
        if(isBold){
            //加粗
            font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
        }
        //设置字体大小
        font.setFontHeightInPoints(fontsize);
        //加载字体
        style.setFont(font);
        return style;
    }

    /**
     *  通过反射获取对象的getter方法，来获取对象的属性值
     * @param obj   对象
     * @param name  对象的属性名称
     * @return      返回对象的属性值
     */
    private static Object getGetMethod(Object obj, String name){
        Method[] m = obj.getClass().getMethods();
        for(int i = 0;i < m.length;i++){
            if(("get"+name).toLowerCase().equals(m[i].getName().toLowerCase())){
                try {
                    return m[i].invoke(obj);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return null;
    }
}
```

## 测试代码

```java
    @RequestMapping("/exportExcel")
    public void exportExcel(HttpServletResponse resp) {
        String[] colTitles = {"姓名","年龄","地址"};
        String[] properties ={"name","age","address"};

        //User对象和Person对象，属性仅有部分相同，若拿相同属性去导出，则可以导出
        User u1 = new User("张三",20,"北京",175);
        User u2 = new User("李四",22,"上海",178);
        User u3 = new User("王五",24,"广州",180);
        Person p1 = new Person("小明",18,"南京","男");
        Person p2 = new Person("小红",26,"武汉","女");
        Person p3 = new Person("小张",21,"杭州","男");

        List<Object> list = new ArrayList<>();
        list.add(u1);list.add(u2);list.add(u3);
        list.add(p1);list.add(p2);list.add(p3);

        Map<String, Object> result = ExcelUtils.exportExcel(list, colTitles, properties, "用户列表", "用户数据统计表", resp);
        System.out.println(result.get("msg"));
        System.out.println(result.get("success"));
    }
```

## 测试结果

![](https://pan.layne666.cn/images/2021/12/02/YCV0kjjEqz.png)

![](https://pan.layne666.cn/images/2021/12/02/X2ssxou9oU.png)

![](https://pan.layne666.cn/images/2021/12/02/NZyufHaB8N.png)