import { RefreshLayoutStatus } from "@abner/refresh"

/**
 *
 *
 * @author yongoe
 * @since 2025−03-12
 * @version v1.0
 */
@Component
export struct RefreshHeaderComponent {
  @Prop @Watch('change') status: RefreshLayoutStatus
  @State time: string = ''

  change() {
    if (this.status == RefreshLayoutStatus.Finish) {
      this.updateTIme()
    }
  }

  aboutToAppear(): void {
    this.updateTIme()
  }

  updateTIme() {
    // 创建一个新的日期对象，获取当前日期和时间
    const currentDate = new Date();
    // 获取年份（四位数）
    const year = currentDate.getFullYear();
    // 获取月份（两位数，补零）
    const month = String(currentDate.getMonth() + 1).padStart(2, '0');
    // 获取日期（两位数，补零）
    const day = String(currentDate.getDate()).padStart(2, '0');
    // 获取小时（两位数，补零，24小时制）
    const hours = String(currentDate.getHours()).padStart(2, '0');
    // 获取分钟（两位数，补零）
    const minutes = String(currentDate.getMinutes()).padStart(2, '0');
    // 获取秒（两位数，补零）
    const seconds = String(currentDate.getSeconds()).padStart(2, '0');
    // 拼接成所需的字符串格式
    this.time = `${month}-${day} ${hours}:${minutes}`;

  }

  build() {
    Column() {
      if (this.status == RefreshLayoutStatus.Pulling) {
        Text('下拉刷新')
          .fontColor('#666')
          .fontSize(12)
      } else if (this.status == RefreshLayoutStatus.Release) {
        Text('松开立即刷新')
          .fontColor('#666')
          .fontSize(12)
      } else if (this.status == RefreshLayoutStatus.Refreshing) {
        Text('刷新中')
          .fontColor('#666')
          .fontSize(12)
      } else if (this.status == RefreshLayoutStatus.Finish) {
        Text('刷新完成')
          .fontColor('#666')
          .fontSize(12)
      }


      Text(`上次刷新：${this.time}`)
        .fontSize(10)
        .fontColor('#999')
    }
    .height(100)
    .justifyContent(FlexAlign.Center)
  }
}