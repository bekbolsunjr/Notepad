import Foundation
import UIKit

class PrintModel {
    //MARK: - Properties
    private let printViewer: PrintViewer
    private var images: [UIImage]
    
    //MARK: - Initialize
    init(printViewer: PrintViewer) {
        self.printViewer = printViewer
        images = []
    }
    
    //MARK: - Methods
    func createImage(text: String,
                     font: UIFont) {

        //Создаем фрейм размера А4
        let frame = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)

        //Создаем параметр строки в который передаем шрифт
        let attributes = [NSAttributedString.Key.font: font]
        let attrString = NSAttributedString(string: text, attributes: attributes)

        //Создаем средство визуализации графики для создания изображения
        let render = UIGraphicsImageRenderer(size: frame.size)

        //Устанавливаем текущую длину текста на 0 и запускаем цикл, пока длина текущего текста не будет меньше длине текста печати
        var textPosition = 0
        while textPosition < attrString.length {

            //Создаем объект установки фрейма из строки.
            let frameSetter = CTFramesetterCreateWithAttributedString(attrString)

            //Создаем frame для текста с отступами x и y
            let textFrame = frame.insetBy(dx: 10, dy: 20)

            //Создаем frame для нумерации страниц
            let numberFrame = CGRect(x: 0, y: frame.height - 20, width: frame.width - 10, height: 20)

            let path = CGMutablePath()
            path.addRect(textFrame)

            //Создаем фреймсеттер, который продолжает заполнять фрейм до тех пор, пока в нем либо не закончится текст, либо он не обнаружит, что текст больше не помещается.
            let ctframe = CTFramesetterCreateFrame(frameSetter, CFRangeMake(textPosition, 0), path, nil)

            //Создаем переменную в которую передаем массив строк, сохраненных во фрейме.
            let linesCFArray: NSArray = CTFrameGetLines(ctframe)
            let lines = linesCFArray as Array

            //Создаем изображение
            let image = render.image { renderContext in

                //Изменяет начало координат для рисований строк
                renderContext.cgContext.translateBy(x: 0, y: frame.size.height)
                renderContext.cgContext.scaleBy(x: 1.0, y: -1.0)

                //Запускаем цикл для рисования строк
                var index = CFIndex(0)
                for line in lines {
                    var lineOrigin: CGPoint = CGPoint.zero

                    //Получаем начало координат строки по индексу
                    CTFrameGetLineOrigins(ctframe, CFRangeMake(index, 1), &lineOrigin)

                    //Задаем позицию строки по x и y
                    renderContext.cgContext.textPosition = .init(x: lineOrigin.x + 10, y: lineOrigin.y + 20)
                    let ctline = line as! CTLine

                    //Запускаем отрисовку строки
                    CTLineDraw(ctline, renderContext.cgContext)
                    index += 1
                }

                //Создаем номер страницы
                let numberString = String(images.count + 1)
                let numberAttributedString = NSAttributedString(string: numberString)
                let numberLine = CTLineCreateWithAttributedString(numberAttributedString)
                
                renderContext.cgContext.textPosition = .init(x: numberFrame.width/2, y: 5)
                
                //Прорисовываем номер страницы
                CTLineDraw(numberLine, renderContext.cgContext)
            }

            //Добавляем диапазон символов, которые фактически поместились во фрейм.
            let frameRange = CTFrameGetVisibleStringRange(ctframe)
            textPosition += frameRange.length

            //Передаем в массив наше изображение
            images.append(image)
        }

        //Передаем во viewer массив изображений и запускаем печать
        printViewer.launchPrint(image: images)
    }
}
