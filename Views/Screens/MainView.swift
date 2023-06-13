//
//  MainView.swift
//  Doggy
//
//  Created by Karyna Khotin on 14.05.2023.
//

import SwiftUI
import PhotosUI
import CoreGraphics

struct MainView: View {
    @EnvironmentObject var context: AppContext
    
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                camera
                VStack {
                    header
                    Spacer()
                    footer
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationDestination(for: Prediction.self) { prediction in
                PredictionDetailsView(prediction: prediction)
            }
        }
    }
    
    private var header: some View {
        Text("Doggy 🐶")
            .font(
                .custom(
                    "Optima-ExtraBlack",
                    fixedSize: 42)
                .weight(.black)
            )
            .foregroundColor(Color(hex: 0xF5D7E6))
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16.0))
    }
    
    private var footer: some View {
        HStack(spacing: 16) {
            prediction
            
            galleryButton
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(16)
    }
        
    private var camera: some View {
        ViewModelBuilder(
            viewModelBuilder: { context in
                CameraViewModel(camera: context.camera)
            },
            viewBuilder: CameraView.init(model:)
        )
        .ignoresSafeArea()
    }
    
    private var prediction: some View {
        ViewModelBuilder(
            viewModelBuilder: LivePredictionViewModel.init(context:)
        ) { viewModel in
            NavigationLink(value: viewModel.prediction) {
                LivePredictionView(model: viewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.accentColor)
                    .padding(16)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            }
        }
    }
    
    @State private var selectedItem: PhotosPickerItem? = nil
    
    private var galleryButton: some View {
        ViewModelBuilder(
            viewModelBuilder: PhotoPickerPredictionViewModel.init(context:)
        ) { viewModel in
            let selectionBinding = Binding(
                get: {
                    viewModel.imageSelection
                },
                set: { newValue in
                    viewModel.imageSelection = newValue
                })
            
            return PhotosPicker(
                selection: selectionBinding,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Image(systemName: "photo.stack")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.accentColor)
                    .padding(16)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            }
            .onChange(of: viewModel.prediction) { prediction in
                guard let prediction else { return }
                navigationPath.append(prediction)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AppContext.mock())
    }
}
