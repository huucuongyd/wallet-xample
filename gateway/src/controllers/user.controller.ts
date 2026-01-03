import { Body, Controller, Get, Inject, Param, Patch, Post } from "@nestjs/common";
import { ClientProxy } from "@nestjs/microservices";
import { firstValueFrom } from "rxjs";
import { CreateUserDto, UpdateUserDto } from "src/dtos/user.dto";

@Controller('user')
export class UserController {
  constructor(
    @Inject('USER_SERVICE')
    private readonly userClient: ClientProxy,
  ) {}

  @Get(':id')
  async getUserById(@Param('id') id: string) {
    return await firstValueFrom(this.userClient.send('get_user', { id }));
  }

  @Get('me')
  async getMe() {
    return await firstValueFrom(this.userClient.send('get_me', {}));
  }

  @Post('')
  async createUser(@Body() createUserDto: CreateUserDto) {
    return await firstValueFrom(this.userClient.send('create_user', createUserDto));
  }

  @Patch(':id')
  async updateUser(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto) {
    return await firstValueFrom(this.userClient.send('update_user', { id, updateUserDto }));
  }
}