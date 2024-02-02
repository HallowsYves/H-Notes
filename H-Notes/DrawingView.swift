//
//  DrawingView.swift
//  TestDraw
//
//  Created by Yves Velasquez on 2/1/24.
//

import SwiftUI

struct DrawingView: View {
    
    @State private var lines = [Line]()
    
    @State private var selectedColor: Color = .black
    @State private var selectedLineWidth: CGFloat = 1
    
    let engine = DrawingEngine()
    
    var body: some View {
        
        VStack{
            HStack{
                ColorPicker("Line Color", selection: $selectedColor).labelsHidden()
                
                
                Slider(value: $selectedLineWidth, in: 1...10){
                    Text("Width:")
                }.frame(maxWidth: 200)
                Text(String(format: "%.0f", selectedLineWidth))
                
                Button(action: {lines = [Line]() }, label: {
                    Text("Delete")
                }).foregroundColor(.red)
                
            }.padding()
            
            
            Canvas{ context, size in
                
                for line in lines {
                    
                    let path = engine.createPath(for: line.points)
                    context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
                    
//                    for point in line.points{
//                        context.draw(Image(systemName: "plus"), at:point)
//                    }
                }
            }
            
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({value in
                let newPoint = value.location
                if value.translation.width + value.translation.height == 0 {
                    lines.append(Line(points: [newPoint], color: selectedColor, lineWidth: selectedLineWidth))
                } else{
                    let index = lines.count - 1
                    lines[index].points.append(newPoint)
                }
            }))
        }
    }
}

#Preview {
    DrawingView()
}
