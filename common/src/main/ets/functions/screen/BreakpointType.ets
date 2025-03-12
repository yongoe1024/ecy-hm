/**
 * 屏幕断点工具
 */
export class BreakpointType {
  static of<T>(sm: T, md: T, lg: T, currentWidthBreakpoint: string) {
    if (currentWidthBreakpoint === 'sm') {
      return sm;
    }
    if (currentWidthBreakpoint === 'md') {
      return md;
    }
    if (currentWidthBreakpoint === 'lg') {
      return lg;
    }
    return sm;
  }
}

// Text('Test')
//  .fontSize(  BreakpointType.of('14fp', '16fp', '18fp',this.currentWidthBreakpoint) )