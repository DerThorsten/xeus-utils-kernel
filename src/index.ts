// Copyright (c) Thorsten Beier
// Copyright (c) JupyterLite Contributors
// Distributed under the terms of the Modified BSD License.

import {
  JupyterLiteServer,
  JupyterLiteServerPlugin
} from '@jupyterlite/server';

import { IKernel, IKernelSpecs } from '@jupyterlite/kernel';

import { XeusServerKernel } from './xeus_server_kernel';

import logo32 from '../style/logos/utils-logo-32x32.png';

import logo64 from '../style/logos/utils-logo-64x64.png';

const server_kernel: JupyterLiteServerPlugin<void> = {
  id: '@jupyterlite/xeus-utils-kernel-extension:kernel',
  autoStart: true,
  requires: [IKernelSpecs],
  activate: (app: JupyterLiteServer, kernelspecs: IKernelSpecs) => {
    kernelspecs.register({
      spec: {
        name: 'Utils',
        display_name: 'Utils',
        language: 'text',
        argv: [],
        spec: {
          argv: [],
          env: {},
          display_name: 'Utils',
          language: 'text',
          interrupt_mode: 'message',
          metadata: {}
        },
        resources: {
          'logo-32x32': logo32,
          'logo-64x64': logo64
        }
      },
      create: async (options: IKernel.IOptions): Promise<IKernel> => {
        return new XeusServerKernel({
          ...options
        });
      }
    });
  }
};

const plugins: JupyterLiteServerPlugin<any>[] = [server_kernel];

export default plugins;
