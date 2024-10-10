import SwiftUI

struct ContentView: View {
    @State private var redValue: Double = 0.0
    @State private var greenValue: Double = 0.0
    @State private var blueValue: Double = 0.0
    
    @State private var cyanValue: Double = 0.0
    @State private var magentaValue: Double = 0.0
    @State private var yellowValue: Double = 0.0
    @State private var blackValue: Double = 0.0
    
    @State private var hueValue: Double = 0.0
    @State private var saturationValue: Double = 0.0
    @State private var lightnessValue: Double = 0.0
    
    @State private var selectedColor: Color = .white

    var body: some View {
        ZStack {
            Color(red: redValue / 255, green: greenValue / 255, blue: blueValue / 255)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                ColorPicker("Choose Color", selection: $selectedColor, supportsOpacity: false)
                    .onChange(of: selectedColor) { newColor in
                        colorPickerChanged(to: newColor)
                    }
                    .bold()
                    .padding()

                Divider()
                Text("RGB").bold()
                HStack {
                    TextField("Red", value: $redValue, formatter: NumberFormatter())
                        .frame(width: 60)
                    Slider(value: $redValue, in: 0...255, step: 1, onEditingChanged: { _ in
                        rgbChanged()
                    })
                    .accentColor(.red)
                }
                HStack {
                    TextField("Green", value: $greenValue, formatter: NumberFormatter())
                        .frame(width: 60)
                    Slider(value: $greenValue, in: 0...255, step: 1, onEditingChanged: { _ in
                        rgbChanged()
                    })
                    .accentColor(.green)
                }
                HStack {
                    TextField("Blue", value: $blueValue, formatter: NumberFormatter())
                        .frame(width: 60)
                    Slider(value: $blueValue, in: 0...255, step: 1, onEditingChanged: { _ in
                        rgbChanged()
                    })
                    .accentColor(.blue)
                }

                Divider()

                Text("CMYK").bold()
                HStack {
                    TextField("Cyan", value: $cyanValue, formatter: NumberFormatter())
                        .frame(width: 60)
                    Slider(value: $cyanValue, in: 0...1, step: 0.01, onEditingChanged: { _ in
                        cmykChanged()
                    })
                    .accentColor(.cyan)
                }
                HStack {
                    TextField("Magenta", value: $magentaValue, formatter: NumberFormatter())
                        .frame(width: 60)
                    Slider(value: $magentaValue, in: 0...1, step: 0.01, onEditingChanged: { _ in
                        cmykChanged()
                    })
                    .accentColor(.pink)
                }
                HStack {
                    TextField("Yellow", value: $yellowValue, formatter: NumberFormatter())
                        .frame(width: 60)
                    Slider(value: $yellowValue, in: 0...1, step: 0.01, onEditingChanged: { _ in
                        cmykChanged()
                    })
                    .accentColor(.yellow)
                }
                HStack {
                    TextField("Black", value: $blackValue, formatter: NumberFormatter())
                        .frame(width: 60)
                    Slider(value: $blackValue, in: 0...1, step: 0.01, onEditingChanged: { _ in
                        cmykChanged()
                    })
                    .accentColor(.black)
                }

                Divider()

                Text("HLS").bold()
                HStack {
                    TextField("Hue", value: $hueValue, formatter: NumberFormatter())
                        .frame(width: 60)
                    Slider(value: $hueValue, in: 0...1, step: 0.01, onEditingChanged: { _ in
                        hlsChanged()
                    })
                    .accentColor(.orange)
                }
                HStack {
                    TextField("Saturation", value: $saturationValue, formatter: NumberFormatter())
                        .frame(width: 60)
                    Slider(value: $saturationValue, in: 0...1, step: 0.01, onEditingChanged: { _ in
                        hlsChanged()
                    })
                    .accentColor(.purple)
                }
                HStack {
                    TextField("Lightness", value: $lightnessValue, formatter: NumberFormatter())
                        .frame(width: 60)
                    Slider(value: $lightnessValue, in: 0...1, step: 0.01, onEditingChanged: { _ in
                        hlsChanged()
                    })
                    .accentColor(.gray)
                }
            }
            .padding()
        }
    }

    func colorPickerChanged(to color: Color) {
        let uiColor = UIColor(color)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)

        redValue = Double(r * 255)
        greenValue = Double(g * 255)
        blueValue = Double(b * 255)

        rgbChanged()
    }

    func rgbChanged() {
        let (c, m, y, k) = rgbToCmyk(r: redValue, g: greenValue, b: blueValue)
        cyanValue = c
        magentaValue = m
        yellowValue = y
        blackValue = k

        let (h, l, s) = rgbToHls(r: redValue, g: greenValue, b: blueValue)
        hueValue = h
        lightnessValue = l
        saturationValue = s
    }

    func cmykChanged() {
        let (r, g, b) = cmykToRgb(c: cyanValue, m: magentaValue, y: yellowValue, k: blackValue)
        redValue = r
        greenValue = g
        blueValue = b
        rgbChanged()
    }

    func hlsChanged() {
        let (r, g, b) = hlsToRgb(h: hueValue, l: lightnessValue, s: saturationValue)
        redValue = r
        greenValue = g
        blueValue = b
        rgbChanged()
    }

    func rgbToCmyk(r: Double, g: Double, b: Double) -> (c: Double, m: Double, y: Double, k: Double) {
        let r = r / 255
        let g = g / 255
        let b = b / 255

        let k = 1 - max(r, g, b)
        let c = (1 - r - k) / (1 - k)
        let m = (1 - g - k) / (1 - k)
        let y = (1 - b - k) / (1 - k)
        return (c: c, m: m, y: y, k: k)
    }
    
    func cmykToRgb(c: Double, m: Double, y: Double, k: Double) -> (r: Double, g: Double, b: Double) {
        let r = 255 * (1 - c) * (1 - k)
        let g = 255 * (1 - m) * (1 - k)
        let b = 255 * (1 - y) * (1 - k)
        return (r: r, g: g, b: b)
    }

    func rgbToHls(r: Double, g: Double, b: Double) -> (h: Double, l: Double, s: Double) {
        let color = UIColor(red: CGFloat(r / 255), green: CGFloat(g / 255), blue: CGFloat(b / 255), alpha: 1.0)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return (h: Double(hue), l: Double(brightness), s: Double(saturation))
    }

    func hlsToRgb(h: Double, l: Double, s: Double) -> (r: Double, g: Double, b: Double) {
        let color = UIColor(hue: CGFloat(h), saturation: CGFloat(s), brightness: CGFloat(l), alpha: 1.0)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (r: Double(red) * 255, g: Double(green) * 255, b: Double(blue) * 255)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

