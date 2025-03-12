/**
 * Text 按钮样式
 */
export class TextOneModifier implements AttributeModifier<TextAttribute> {
  private level: number

  constructor(level: 1 | 2 | 3) {
    this.level = level
  }

  applyNormalAttribute(instance: TextAttribute): void {
    if (this.level === 1) {
      instance.height(56)
      instance.fontSize(16)
      instance.padding({
        left: 32,
        right: 32
      })
    } else if (this.level === 2) {
      instance.height(32)
      instance.fontSize(12)
      instance.padding({
        left: 8,
        right: 8
      })
    } else {
      instance.height(44)
      instance.fontSize(12)
      instance.padding({
        left: 24,
        right: 24
      })
    }
    instance.textAlign(TextAlign.Center)
    instance.fontColor("#E5E5E5")
    instance.backgroundColor("#000000")
  }

  applyPressedAttribute(instance: TextAttribute): void {
    if (this.level === 1) {
      instance.height(56)
      instance.fontSize(16)
      instance.padding({
        left: 32,
        right: 32
      })
    } else if (this.level === 2) {
      instance.height(32)
      instance.fontSize(12)
      instance.padding({
        left: 8,
        right: 8
      })
    } else {
      instance.height(44)
      instance.fontSize(12)
      instance.padding({
        left: 24,
        right: 24
      })
    }

    instance.textAlign(TextAlign.Center)
    instance.fontColor("#E5E5E5")

    instance.backgroundColor("#4C4C4C")
  }

  applyDisabledAttribute(instance: TextAttribute): void {
    if (this.level === 1) {
      instance.height(56)
      instance.fontSize(16)
      instance.padding({
        left: 32,
        right: 32
      })
    } else if (this.level === 2) {
      instance.height(32)
      instance.fontSize(12)
      instance.padding({
        left: 8,
        right: 8
      })
    } else {
      instance.height(44)
      instance.fontSize(12)
      instance.padding({
        left: 24,
        right: 24
      })
    }

    instance.textAlign(TextAlign.Center)
    instance.fontColor("#E5E5E5")

    instance.backgroundColor("#B3B3B3")
  }
}

export class TextTwoModifier implements AttributeModifier<TextAttribute> {
  private level: number

  constructor(level: 1 | 2 | 3) {
    this.level = level
  }

  applyNormalAttribute(instance: TextAttribute): void {
    if (this.level === 1) {
      instance.height(56)
      instance.fontSize(16)
      instance.padding({
        left: 32,
        right: 32
      })
    } else if (this.level === 2) {
      instance.height(32)
      instance.fontSize(12)
      instance.padding({
        left: 8,
        right: 8
      })
    } else {
      instance.height(44)
      instance.fontSize(12)
      instance.padding({
        left: 24,
        right: 24
      })
    }
    instance.textAlign(TextAlign.Center)
    instance.backgroundColor("#FFFFFF")
    instance.fontColor("#333333")
    instance.border({
      width: 1,
      color: "#000000"
    })
  }

  applyPressedAttribute(instance: TextAttribute): void {
    if (this.level === 1) {
      instance.height(56)
      instance.fontSize(16)
      instance.padding({
        left: 32,
        right: 32
      })
    } else if (this.level === 2) {
      instance.height(32)
      instance.fontSize(12)
      instance.padding({
        left: 8,
        right: 8
      })
    } else {
      instance.height(44)
      instance.fontSize(12)
      instance.padding({
        left: 24,
        right: 24
      })
    }

    instance.textAlign(TextAlign.Center)
    instance.backgroundColor("#E5E5E5")
    instance.fontColor("#333333")
    instance.border({
      width: 1,
      color: "#4C4C4C"
    })
  }

  applyDisabledAttribute(instance: TextAttribute): void {
    if (this.level === 1) {
      instance.height(56)
      instance.fontSize(16)
      instance.padding({
        left: 32,
        right: 32
      })
    } else if (this.level === 2) {
      instance.height(32)
      instance.fontSize(12)
      instance.padding({
        left: 8,
        right: 8
      })
    } else {
      instance.height(44)
      instance.fontSize(12)
      instance.padding({
        left: 24,
        right: 24
      })
    }
    instance.textAlign(TextAlign.Center)
    instance.backgroundColor("#FFFFFF")
    instance.fontColor("#B3B3B3")
    instance.border({
      width: 1,
      color: "#B3B3B3"
    })
  }
}

export class TextThreeModifier implements AttributeModifier<TextAttribute> {
  private level: number

  constructor(level: 1 | 2 | 3) {
    this.level = level
  }

  applyNormalAttribute(instance: TextAttribute): void {
    if (this.level === 1) {
      instance.height(56)
      instance.fontSize(16)
      instance.padding({
        left: 32,
        right: 32
      })
    } else if (this.level === 2) {
      instance.height(32)
      instance.fontSize(12)
      instance.padding({
        left: 8,
        right: 8
      })
    } else {
      instance.height(44)
      instance.fontSize(12)
      instance.padding({
        left: 24,
        right: 24
      })
    }
    instance.textAlign(TextAlign.Center)
    instance.backgroundColor("#FFFFFF")
    instance.fontColor("#333333")
  }

  applyPressedAttribute(instance: TextAttribute): void {
    if (this.level === 1) {
      instance.height(56)
      instance.fontSize(16)
      instance.padding({
        left: 32,
        right: 32
      })
    } else if (this.level === 2) {
      instance.height(32)
      instance.fontSize(12)
      instance.padding({
        left: 8,
        right: 8
      })
    } else {
      instance.height(44)
      instance.fontSize(12)
      instance.padding({
        left: 24,
        right: 24
      })
    }
    instance.textAlign(TextAlign.Center)
    instance.backgroundColor("#E5E5E5")
    instance.fontColor("#333333")
  }

  applyDisabledAttribute(instance: TextAttribute): void {
    if (this.level === 1) {
      instance.height(56)
      instance.fontSize(16)
      instance.padding({
        left: 32,
        right: 32
      })
    } else if (this.level === 2) {
      instance.height(32)
      instance.fontSize(12)
      instance.padding({
        left: 8,
        right: 8
      })
    } else {
      instance.height(44)
      instance.fontSize(12)
      instance.padding({
        left: 24,
        right: 24
      })
    }

    instance.textAlign(TextAlign.Center)
    instance.backgroundColor("#FFFFFF")
    instance.fontColor("#B3B3B3")
  }
}
 