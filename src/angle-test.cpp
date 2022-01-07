/**
 * This test application is a derivative work based on the following code samples:
 *
 * 1. https://arm-software.github.io/opengl-es-sdk-for-android/simple_cube.html
 *
 * Copyright (c) 2013-2017, ARM Limited and Contributors
 *
 * SPDX-License-Identifier: MIT
 *
 * Permission is hereby granted, free of charge,
 * to any person obtaining a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * 2. https://docs.microsoft.com/en-us/windows/win32/learnwin32/your-first-windows-program
 *
 * Modified and distributed as permitted by the following clause:
 *
 * "You may also:
 * - Modify and distribute source code and objects for code marked as “sample” or “Code Snippet”."
 *
 * https://www.microsoft.com/en-us/download/details.aspx?id=13350 "Visual Studio Licensing Whitepaper - November 2016"
 */

#define EGL_EGLEXT_PROTOTYPES

#include <assert.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/* Windows, nonportable */
#include <sysinfoapi.h>

#include <GL/gl.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>

#define MAX_CONFIGS 10
#define MAX_MODES 100

#ifndef M_PI
#define M_PI 3.14159265
#endif

/* return current time (in seconds) */
static double
current_time(void)
{
    FILETIME ft;
    ULARGE_INTEGER ul;
    GetSystemTimePreciseAsFileTime(&ft);
    ul.LowPart = ft.dwLowDateTime;
    ul.HighPart = ft.dwHighDateTime;
    return 1e-7 * ul.QuadPart;
}

float matrixDegreesToRadians(float degrees)
{
        return M_PI * degrees / 180.0f;
}

/* [matrixIdentity] */
void matrixIdentityFunction(float* matrix)
{
    if(matrix)
    {
        memset(matrix, '\0', sizeof(float) * 16);
        matrix[0] = matrix[5] = matrix[10] = matrix[15] = 1.0f;
    }
}
/* [matrixIdentity] */

/* [matrixMultiply] */
void matrixMultiply(float* destination, float* operand1, float* operand2)
{
    float theResult[16];
    int row, column = 0;
    int i,j = 0;
    for(i = 0; i < 4; i++)
    {
        for(j = 0; j < 4; j++)
        {
            theResult[4 * i + j] = operand1[j] * operand2[4 * i] + operand1[4 + j] * operand2[4 * i + 1] +
                operand1[8 + j] * operand2[4 * i + 2] + operand1[12 + j] * operand2[4 * i + 3];
        }
    }

    for(int i = 0; i < 16; i++)
    {
        destination[i] = theResult[i];
    }
}
/* [matrixMultiply] */

/* [matrixTranslate] */
void matrixTranslate(float* matrix, float x, float y, float z)
{
    float temporaryMatrix[16];
    matrixIdentityFunction(temporaryMatrix);
    temporaryMatrix[12] = x;
    temporaryMatrix[13] = y;
    temporaryMatrix[14] = z;
    matrixMultiply(matrix,temporaryMatrix,matrix);
}
/* [matrixTranslate] */

/* [matrixFrustum] */
void matrixFrustum(float* matrix, float left, float right, float bottom, float top, float zNear, float zFar)
{
    float temp, xDistance, yDistance, zDistance;
    temp = 2.0 *zNear;
    xDistance = right - left;
    yDistance = top - bottom;
    zDistance = zFar - zNear;
    matrixIdentityFunction(matrix);
    matrix[0] = temp / xDistance;
    matrix[5] = temp / yDistance;
    matrix[8] = (right + left) / xDistance;
    matrix[9] = (top + bottom) / yDistance;
    matrix[10] = (-zFar - zNear) / zDistance;
    matrix[11] = -1.0f;
    matrix[14] = (-temp * zFar) / zDistance;
    matrix[15] = 0.0f;
}
/* [matrixFrustum] */

/* [matrixPerspective] */
void matrixPerspective(float* matrix, float fieldOfView, float aspectRatio, float zNear, float zFar)
{
    float ymax, xmax;
    ymax = zNear * tanf(fieldOfView * M_PI / 360.0);
    xmax = ymax * aspectRatio;
    matrixFrustum(matrix, -xmax, xmax, -ymax, ymax, zNear, zFar);
}
/* [matrixPerspective] */

/* [matrixRotate] */
void matrixRotateX(float* matrix, float angle)
{
    float tempMatrix[16];
    matrixIdentityFunction(tempMatrix);

    tempMatrix[5] = cos(matrixDegreesToRadians(angle));
    tempMatrix[9] = -sin(matrixDegreesToRadians(angle));
    tempMatrix[6] = sin(matrixDegreesToRadians(angle));
    tempMatrix[10] = cos(matrixDegreesToRadians(angle));
    matrixMultiply(matrix, tempMatrix, matrix);
}

void matrixRotateY(float *matrix, float angle)
{
    float tempMatrix[16];
    matrixIdentityFunction(tempMatrix);

    tempMatrix[0] = cos(matrixDegreesToRadians(angle));
    tempMatrix[8] = sin(matrixDegreesToRadians(angle));
    tempMatrix[2] = -sin(matrixDegreesToRadians(angle));
    tempMatrix[10] = cos(matrixDegreesToRadians(angle));
    matrixMultiply(matrix, tempMatrix, matrix);
}

void matrixRotateZ(float *matrix, float angle)
{
    float tempMatrix[16];
    matrixIdentityFunction(tempMatrix);

    tempMatrix[0] = cos(matrixDegreesToRadians(angle));
    tempMatrix[4] = -sin(matrixDegreesToRadians(angle));
    tempMatrix[1] = sin(matrixDegreesToRadians(angle));
    tempMatrix[5] = cos(matrixDegreesToRadians(angle));
    matrixMultiply(matrix, tempMatrix, matrix);
}
/* [matrixRotate] */

/* [matrixScale] */
void matrixScale(float* matrix, float x, float y, float z)
{
    float tempMatrix[16];
    matrixIdentityFunction(tempMatrix);

    tempMatrix[0] = x;
    tempMatrix[5] = y;
    tempMatrix[10] = z;
    matrixMultiply(matrix, tempMatrix, matrix);
}
/* [matrixScale] */


/* Copyright (c) 2013-2017, ARM Limited and Contributors
 *
 * SPDX-License-Identifier: MIT
 *
 * Permission is hereby granted, free of charge,
 * to any person obtaining a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#include <GLES2/gl2.h>
#include <GLES2/gl2ext.h>

#include <cstdio>
#include <cstdlib>
#include <cmath>

/* [vertexShader] */
static const char  glVertexShader[] =
        "attribute vec4 vertexPosition;\n"
        "attribute vec3 vertexColour;\n"
        "varying vec3 fragColour;\n"
        "uniform mat4 projection;\n"
        "uniform mat4 modelView;\n"
        "void main()\n"
        "{\n"
        "    gl_Position = projection * modelView * vertexPosition;\n"
        "    fragColour = vertexColour;\n"
        "}\n";
/* [vertexShader] */

/* [fragmentShader] */
static const char  glFragmentShader[] =
        "precision mediump float;\n"
        "varying vec3 fragColour;\n"
        "void main()\n"
        "{\n"
        "    gl_FragColor = vec4(fragColour, 1.0);\n"
        "}\n";
/* [fragmentShader] */

GLuint loadShader(GLenum shaderType, const char* shaderSource)
{
    GLuint shader = glCreateShader(shaderType);
    if (shader != 0)
    {
        glShaderSource(shader, 1, &shaderSource, NULL);
        glCompileShader(shader);
        GLint compiled = 0;
        glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
        if (compiled != GL_TRUE)
        {
            GLint infoLen = 0;
            glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);

            if (infoLen > 0)
            {
                char * logBuffer = (char*) malloc(infoLen);

                if (logBuffer != NULL)
                {
                    glGetShaderInfoLog(shader, infoLen, NULL, logBuffer);
                    fprintf(stderr, "Could not Compile Shader %d:\n%s\n", shaderType, logBuffer);
                    free(logBuffer);
                    logBuffer = NULL;
                }

                glDeleteShader(shader);
                shader = 0;
            }
        }
    }

    return shader;
}

GLuint createProgram(const char* vertexSource, const char * fragmentSource)
{
    GLuint vertexShader = loadShader(GL_VERTEX_SHADER, vertexSource);
    if (vertexShader == 0)
    {
        return 0;
    }

    GLuint fragmentShader = loadShader(GL_FRAGMENT_SHADER, fragmentSource);
    if (fragmentShader == 0)
    {
        return 0;
    }

    GLuint program = glCreateProgram();

    if (program != 0)
    {
        glAttachShader(program, vertexShader);
        glAttachShader(program, fragmentShader);
        glLinkProgram(program);
        GLint linkStatus = GL_FALSE;
        glGetProgramiv(program, GL_LINK_STATUS, &linkStatus);
        if(linkStatus != GL_TRUE)
        {
            GLint bufLength = 0;
            glGetProgramiv(program, GL_INFO_LOG_LENGTH, &bufLength);
            if (bufLength > 0)
            {
                char* logBuffer = (char*) malloc(bufLength);

                if (logBuffer != NULL)
                {
                    glGetProgramInfoLog(program, bufLength, NULL, logBuffer);
                    fprintf(stderr, "Could not link program:\n%s\n", logBuffer);
                    free(logBuffer);
                    logBuffer = NULL;
                }
            }
            glDeleteProgram(program);
            program = 0;
        }
    }
    return program;
}

GLuint simpleCubeProgram;
GLuint vertexLocation;
GLuint vertexColourLocation;
GLuint projectionLocation;
GLuint modelViewLocation;

float projectionMatrix[16];
float modelViewMatrix[16];
float angle = 0;

/* [setupGraphics] */
bool setupGraphics(int width, int height)
{
    simpleCubeProgram = createProgram(glVertexShader, glFragmentShader);

    if (simpleCubeProgram == 0)
    {
        fprintf(stderr, "Could not create program");
        return false;
    }

    vertexLocation = glGetAttribLocation(simpleCubeProgram, "vertexPosition");
    vertexColourLocation = glGetAttribLocation(simpleCubeProgram, "vertexColour");
    projectionLocation = glGetUniformLocation(simpleCubeProgram, "projection");
    modelViewLocation = glGetUniformLocation(simpleCubeProgram, "modelView");

    /* Setup the perspective */
    matrixPerspective(projectionMatrix, 45, (float)width / (float)height, 0.1f, 100);
    glEnable(GL_DEPTH_TEST);

    glViewport(0, 0, width, height);

    return true;
}
/* [setupGraphics] */

/* [cubeVertices] */
GLfloat cubeVertices[] = {-1.0f,  1.0f, -1.0f, /* Back. */
                           1.0f,  1.0f, -1.0f,
                          -1.0f, -1.0f, -1.0f,
                           1.0f, -1.0f, -1.0f,
                          -1.0f,  1.0f,  1.0f, /* Front. */
                           1.0f,  1.0f,  1.0f,
                          -1.0f, -1.0f,  1.0f,
                           1.0f, -1.0f,  1.0f,
                          -1.0f,  1.0f, -1.0f, /* Left. */
                          -1.0f, -1.0f, -1.0f,
                          -1.0f, -1.0f,  1.0f,
                          -1.0f,  1.0f,  1.0f,
                           1.0f,  1.0f, -1.0f, /* Right. */
                           1.0f, -1.0f, -1.0f,
                           1.0f, -1.0f,  1.0f,
                           1.0f,  1.0f,  1.0f,
                          -1.0f, -1.0f, -1.0f, /* Top. */
                          -1.0f, -1.0f,  1.0f,
                           1.0f, -1.0f,  1.0f,
                           1.0f, -1.0f, -1.0f,
                          -1.0f,  1.0f, -1.0f, /* Bottom. */
                          -1.0f,  1.0f,  1.0f,
                           1.0f,  1.0f,  1.0f,
                           1.0f,  1.0f, -1.0f
                         };
/* [cubeVertices] */
/* [colourComponents] */
GLfloat colour[] = {1.0f, 0.0f, 0.0f,
                    1.0f, 0.0f, 0.0f,
                    1.0f, 0.0f, 0.0f,
                    1.0f, 0.0f, 0.0f,
                    0.0f, 1.0f, 0.0f,
                    0.0f, 1.0f, 0.0f,
                    0.0f, 1.0f, 0.0f,
                    0.0f, 1.0f, 0.0f,
                    0.0f, 0.0f, 1.0f,
                    0.0f, 0.0f, 1.0f,
                    0.0f, 0.0f, 1.0f,
                    0.0f, 0.0f, 1.0f,
                    1.0f, 1.0f, 0.0f,
                    1.0f, 1.0f, 0.0f,
                    1.0f, 1.0f, 0.0f,
                    1.0f, 1.0f, 0.0f,
                    0.0f, 1.0f, 1.0f,
                    0.0f, 1.0f, 1.0f,
                    0.0f, 1.0f, 1.0f,
                    0.0f, 1.0f, 1.0f,
                    1.0f, 0.0f, 1.0f,
                    1.0f, 0.0f, 1.0f,
                    1.0f, 0.0f, 1.0f,
                    1.0f, 0.0f, 1.0f
                   };
/* [colourComponents] */

/* [indices] */
GLushort indices[] = {0, 2, 3, 0, 1, 3, 4, 6, 7, 4, 5, 7, 8, 9, 10, 11, 8, 10, 12, 13, 14, 15, 12, 14, 16, 17, 18, 16, 19, 18, 20, 21, 22,  23, 22};
/* [indices] */

/* [renderFrame] */
void renderFrame()
{
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);

    matrixIdentityFunction(modelViewMatrix);

    matrixRotateX(modelViewMatrix, angle);
    matrixRotateY(modelViewMatrix, angle);

    matrixTranslate(modelViewMatrix, 0.0f, 0.0f, -10.0f);

    glUseProgram(simpleCubeProgram);
    glVertexAttribPointer(vertexLocation, 3, GL_FLOAT, GL_FALSE, 0, cubeVertices);
    glEnableVertexAttribArray(vertexLocation);
    glVertexAttribPointer(vertexColourLocation, 3, GL_FLOAT, GL_FALSE, 0, colour);
    glEnableVertexAttribArray(vertexColourLocation);

    glUniformMatrix4fv(projectionLocation, 1, GL_FALSE, projectionMatrix);
    glUniformMatrix4fv(modelViewLocation, 1, GL_FALSE, modelViewMatrix);

    glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_SHORT, indices);
}

//#ifndef UNICODE
//#define UNICODE
//#endif 

#define APP_WIN_SIZE 600

#include <windows.h>

LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);

// accelerated context
EGLDisplay d;
EGLSurface screen_surf;
EGLContext ctx;

// benchmark
double st, ct;
int frames;

void init_egl(HWND hwnd)
{
    int maj, min;
    EGLConfig configs[MAX_CONFIGS];
    EGLint numConfigs, i;
    EGLBoolean b;
    EGLint screenAttribs[10];
    EGLint count, chosenMode;
    GLboolean printInfo = GL_TRUE;
    EGLint width = APP_WIN_SIZE, height = APP_WIN_SIZE; // TODO query

    const EGLint displayAttributes[] =
    {
        EGL_PLATFORM_ANGLE_TYPE_ANGLE, EGL_PLATFORM_ANGLE_TYPE_D3D9_ANGLE, // hw, d3d9
        // EGL_PLATFORM_ANGLE_DEVICE_TYPE_ANGLE, EGL_PLATFORM_ANGLE_DEVICE_TYPE_D3D_WARP_ANGLE, // sw
        EGL_PLATFORM_ANGLE_MAX_VERSION_MAJOR_ANGLE, 9,
        EGL_PLATFORM_ANGLE_MAX_VERSION_MINOR_ANGLE, 1,
        EGL_NONE,
    };

    const EGLint contextAttribs[] =
    {
        EGL_CONTEXT_CLIENT_VERSION, 2,
        EGL_NONE,
    };

    PFNEGLGETPLATFORMDISPLAYEXTPROC eglGetPlatformDisplayEXT = reinterpret_cast<PFNEGLGETPLATFORMDISPLAYEXTPROC>(eglGetProcAddress("eglGetPlatformDisplayEXT"));

    if (!eglGetPlatformDisplayEXT)
    {
        fprintf(stderr, "Failed to get function eglGetPlatformDisplayEXT");
        exit(1);
    }

    d = eglGetPlatformDisplayEXT(EGL_PLATFORM_ANGLE_ANGLE, GetDC(hwnd), displayAttributes);
    if (d == EGL_NO_DISPLAY)
    {
        fprintf(stderr, "Failed to get EGL display: %08x", eglGetError());
        exit(1);
    }

    if (!eglInitialize(d, &maj, &min)) {
        fprintf(stderr, "eglInitialize failed: %08x\n", eglGetError());
        exit(1);
    }
      
      printf("EGL version = %d.%d\n", maj, min);
      printf("EGL_VENDOR = %s\n", eglQueryString(d, EGL_VENDOR));
      
        /* XXX use ChooseConfig */
      eglGetConfigs(d, configs, MAX_CONFIGS, &numConfigs);
      ctx = eglCreateContext(d, configs[0], EGL_NO_CONTEXT, contextAttribs);
      if (ctx == EGL_NO_CONTEXT) {
            printf("failed to create context\n");
            exit(2);
      }
      
      /* build up screenAttribs array */
      i = 0;
      screenAttribs[i++] = EGL_WIDTH;
      screenAttribs[i++] = APP_WIN_SIZE;
      screenAttribs[i++] = EGL_HEIGHT;
      screenAttribs[i++] = APP_WIN_SIZE;
      screenAttribs[i++] = EGL_NONE;

      screen_surf = eglCreateWindowSurface(d, configs[0], hwnd, screenAttribs);
      if (screen_surf == EGL_NO_SURFACE) {
            printf("failed to create window surface\n");
            exit(3);
      }
      
    // b = eglShowScreenSurface(d, screen, screen_surf, mode[chosenMode]);
    // if (!b) {
    //     printf("show surface failed\n");
    //     return 0;
    // }

      b = eglMakeCurrent(d, screen_surf, screen_surf, ctx);
      if (!b) {
            printf("make current failed\n");
            exit(4);
      }
      
      if (printInfo)
      {
            printf("GL_RENDERER   = %s\n", (char *) glGetString(GL_RENDERER));
            printf("GL_VERSION    = %s\n", (char *) glGetString(GL_VERSION));
            printf("GL_VENDOR     = %s\n", (char *) glGetString(GL_VENDOR));
            printf("GL_EXTENSIONS = %s\n", (char *) glGetString(GL_EXTENSIONS));
      }
      
      setupGraphics(width, height);
}

void destroy_egl()
{
    eglDestroySurface(d, screen_surf);
    eglDestroyContext(d, ctx);
    eglTerminate(d);
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE, LPSTR, int nCmdShow)
{
    // Register the window class.
    const char CLASS_NAME[]  = "Sample Accelerated Window Class";
    
    WNDCLASS wc = { };
    HWND hwnd;

    st = current_time();
    ct = st;
    frames = 0;

    wc.lpfnWndProc   = WindowProc;
    wc.hInstance     = hInstance;
    wc.lpszClassName = CLASS_NAME;

    RegisterClass(&wc);

    // Create the window.

    hwnd = CreateWindowEx(
        0,                              // Optional window styles.
        CLASS_NAME,                     // Window class
        "Sample (AN)GL(E) Program",     // Window text
        WS_OVERLAPPEDWINDOW,            // Window style

        // Size and position
        CW_USEDEFAULT, CW_USEDEFAULT, APP_WIN_SIZE, APP_WIN_SIZE,

        NULL,       // Parent window    
        NULL,       // Menu
        hInstance,  // Instance handle
        NULL        // Additional application data
        );

    if (hwnd == NULL)
    {
        return 0;
    }

    ShowWindow(hwnd, nCmdShow);

    // Run the message loop.
    init_egl(hwnd);

    MSG msg = { };
    while (GetMessage(&msg, NULL, 0, 0))
    {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    GLfloat seconds = ct - st;
    GLfloat fps = frames / seconds;
    printf("%d frames in %3.1f seconds = %6.3f FPS\n", frames, seconds, fps);

    return 0;
}

LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
    switch (uMsg)
    {
    case WM_DESTROY:
        destroy_egl();
        PostQuitMessage(0);
        return 0;

    case WM_PAINT:
        {
            PAINTSTRUCT ps;
            HDC hdc = BeginPaint(hwnd, &ps);

            double tt = current_time();
            double dt = tt - ct;
            ct = tt;
        
            /* advance rotation for next frame */
            angle += 70.0 * dt;  /* 70 degrees per second */
            if (angle > 3600.0)
                angle -= 3600.0;
        
            renderFrame();
            eglSwapBuffers(d, screen_surf);
            frames++;
            EndPaint(hwnd, &ps);

            if(true)//(ct - st < ttr)
            {
                InvalidateRect(hwnd, NULL, false);
                UpdateWindow(hwnd);
            }
            else
            {
                PostQuitMessage(0);
            }
        }
        return 0;

    }
    return DefWindowProc(hwnd, uMsg, wParam, lParam);
}
