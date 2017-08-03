//
//  ViewController.m
//  SceneKit-21
//
//  Created by ShiWen on 2017/8/2.
//  Copyright © 2017年 ShiWen. All rights reserved.
//  SCNProgram

#import "ViewController.h"
#import <SceneKit/SceneKit.h>
#import <GLKit/GLKit.h>

@interface ViewController ()
@property (nonatomic,strong) SCNView *mScenView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mScenView];
    
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.position = SCNVector3Make(0, 0, 30);
    cameraNode.camera.automaticallyAdjustsZRange = YES;
    [self.mScenView.scene.rootNode addChildNode:cameraNode];
    
    SCNText *text = [SCNText textWithString:@"哈哈哈哈" extrusionDepth:3];
    text.font = [UIFont systemFontOfSize:12];
    text.firstMaterial.diffuse.contents = [UIColor blueColor];
    SCNNode *textNdoe = [SCNNode nodeWithGeometry:text];
    textNdoe.position = SCNVector3Make(-15, 0, 10);
    [self.mScenView.scene.rootNode addChildNode:textNdoe];
    
    
//    1、创建着色器
    SCNProgram *program = [SCNProgram program];
//    program.isOpaque = YES;
    
//    2、将自定义着色器和片段着色器加载进来
    program.vertexShader = [[NSString alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"CustomProgram" withExtension:@"vsh"] encoding:NSUTF8StringEncoding error:nil];
    program.fragmentShader = [[NSString alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"CustomProgram" withExtension:@"fsh"] encoding:NSUTF8StringEncoding error:nil];
    
//    3、绑定顶点着色器的属性和几何体
    [program setSemantic:SCNGeometrySourceSemanticVertex forSymbol:@"a_srcPos" options:nil];
    [program setSemantic:SCNGeometrySourceSemanticTexcoord forSymbol:@"a_texcoord" options:nil];
//    4、绑定矩阵变换属性
    [program setSemantic:SCNModelTransform forSymbol:@"u_mv" options:nil];
    [program setSemantic:SCNModelViewProjectionTransform forSymbol:@"u_proj" options:nil];
//    5、给材质设置着色程序
    textNdoe.geometry.firstMaterial.program = program;
//    6、设置块变换的值
    
   __block float morphFactor = 0;
    [textNdoe.geometry.firstMaterial handleBindingOfSymbol:@"factor" usingBlock:^(unsigned int programID, unsigned int location, SCNNode * _Nullable renderedNode, SCNRenderer * _Nonnull renderer) {
        morphFactor += 0.01;
        glUniform1f(location, morphFactor);
    }];
    textNdoe.geometry.firstMaterial.writesToDepthBuffer = NO;
    textNdoe.geometry.firstMaterial.readsFromDepthBuffer = NO;
    textNdoe.renderingOrder = 100;
    SCNAction *moveAction = [SCNAction moveBy:SCNVector3Make(0, 0, -100) duration:10];
    [textNdoe runAction:moveAction];

}

-(SCNView *)mScenView{
    if (!_mScenView) {
        _mScenView = [[SCNView alloc] initWithFrame:self.view.bounds];
        _mScenView.backgroundColor = [UIColor blueColor];
        _mScenView.scene = [SCNScene scene];
        _mScenView.allowsCameraControl = YES;
    }
    return _mScenView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
